# frozen_string_literal: false

require "net/http"
require "json"
require "uri"
require "timeout"

# Simple SSE client for testing streaming endpoints.
# Reads SSE events from a chunked HTTP response.
module SSEClient
  Event = Struct.new(:data, :event, :id, keyword_init: true)

  # POST to a streaming endpoint and collect SSE events.
  # Returns an array of Event structs.
  def self.post_stream(path, body, timeout_seconds: 10, headers: {})
    collect_events(:post, path, body: body, timeout_seconds: timeout_seconds, headers: headers)
  end

  # GET a streaming endpoint and collect SSE events.
  # Returns an array of Event structs.
  def self.get_stream(path, timeout_seconds: 10, headers: {})
    collect_events(:get, path, timeout_seconds: timeout_seconds, headers: headers)
  end

  private

  def self.collect_events(method, path, body: nil, timeout_seconds: 10, headers: {})
    uri = URI("#{BASE_URL}#{path}")
    events = []

    Timeout.timeout(timeout_seconds) do
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        request = case method
                  when :post
                    req = Net::HTTP::Post.new(uri.path)
                    req["Content-Type"] = "application/json"
                    req.body = JSON.generate(body) if body
                    req
                  when :get
                    Net::HTTP::Get.new(uri.request_uri)
                  end

        request["Accept"] = "text/event-stream"
        headers.each { |k, v| request[k] = v }

        http.request(request) do |response|
          buffer = ""
          current_event = nil
          current_data_lines = []

          response.read_body do |chunk|
            buffer << chunk
            while (line_end = buffer.index("\n"))
              line = buffer.slice!(0..line_end).chomp("\r\n").chomp("\n")

              if line.empty?
                # Empty line = event boundary
                if current_data_lines.any?
                  data_str = current_data_lines.join("\n")
                  parsed = begin
                    JSON.parse(data_str)
                  rescue JSON::ParserError
                    data_str
                  end
                  events << Event.new(
                    data: parsed,
                    event: current_event
                  )
                end
                current_event = nil
                current_data_lines = []
              elsif line.start_with?("data: ")
                current_data_lines << line.sub(/\Adata: /, "")
              elsif line.start_with?("data:")
                current_data_lines << line.sub(/\Adata:/, "")
              elsif line.start_with?("event: ")
                current_event = line.sub(/\Aevent: /, "")
              elsif line.start_with?("id: ")
                # ignored for now
              end
            end
          end

          # Handle any remaining data in buffer
          if current_data_lines.any?
            data_str = current_data_lines.join("\n")
            parsed = begin
              JSON.parse(data_str)
            rescue JSON::ParserError
              data_str
            end
            events << Event.new(data: parsed, event: current_event)
          end
        end
      end
    end

    events
  rescue Timeout::Error
    events
  rescue EOFError, IOError, Errno::ECONNRESET
    events
  end
end
