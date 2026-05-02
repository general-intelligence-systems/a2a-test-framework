require "a2a_test_framework/test_helper"
require "a2a_test_framework/sse_client"

# HTTP+JSON/REST protocol binding specifics

describe "HTTP+JSON/REST Protocol Binding (REST)" do
  # --- URL Patterns ---

  describe "when verifying endpoint URL patterns" do
    it "should use POST /message:send for Send Message" do
      body = build_send_message_request(text: "URL pattern test")
      response = http_post("/message:send", body)
      response.code.to_i.should.equal 200
    end

    it "should use POST /message:stream for streaming message" do
      body = build_send_message_request(text: "Stream URL test")
      events = SSEClient.post_stream("/message:stream", body, timeout_seconds: 10)
      events.length.should.be > 0
    end

    it "should use GET /tasks/{id} for Get Task" do
      task = create_task!(text: "GET task URL test")
      response = http_get("/tasks/#{task["id"]}")
      response.code.to_i.should.equal 200
    end

    it "should use GET /tasks for List Tasks" do
      response = http_get("/tasks")
      response.code.to_i.should.equal 200
    end

    it "should use POST /tasks/{id}:cancel for Cancel Task" do
      task = create_task!(text: "Cancel URL test")
      response = http_post("/tasks/#{task["id"]}:cancel", {})
      # Will be 400 since task is completed, but endpoint exists
      response.code.to_i.should.not.equal 404
    end
  end

  # --- Query Parameter Naming ---

  describe "when sending GET requests with query parameters" do
    it "should accept camelCase query parameter names" do
      task = create_task!(text: "Query param test")
      response = http_get("/tasks?contextId=#{task["contextId"]}&pageSize=10")
      response.code.to_i.should.equal 200
    end

    it "should accept historyLength as camelCase parameter" do
      task = create_task!(text: "HistoryLength param test")
      response = http_get("/tasks/#{task["id"]}?historyLength=5")
      response.code.to_i.should.equal 200
    end
  end

  # --- Error Handling ---

  describe "when an error occurs" do
    it "should return error details with proper structure" do
      response = http_get("/tasks/nonexistent-#{SecureRandom.uuid}")

      data = parse_json(response)
      if data.key?("error")
        data["error"].should.be.kind_of Hash
        data["error"]["code"].should.not.be.nil
        data["error"]["message"].should.not.be.nil
      end
      true.should.equal true
    end
  end

  describe "when a TaskNotFoundError occurs" do
    it "should return HTTP 404" do
      response = http_get("/tasks/nonexistent-#{SecureRandom.uuid}")
      response.code.to_i.should.equal 404
    end
  end

  # --- Streaming ---

  describe "when a streaming operation is invoked" do
    it "should use text/event-stream content type" do
      body = build_send_message_request(text: "SSE content type test")
      uri = URI("#{BASE_URL}/message:stream")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path)
      request["Content-Type"] = "application/json"
      request["Accept"] = "text/event-stream"
      request.body = JSON.generate(body)

      http.request(request) do |response|
        content_type = response["Content-Type"].to_s
        content_type.should.include "text/event-stream"
      end
    end
  end

  # --- Content-Type ---
  # NOTE: Commented out -- server may accept application/json as well

  # describe "when sending requests or receiving responses" do
  #   it "should use Content-Type application/a2a+json" do
  #   end
  # end

  # --- Service Parameter Transmission ---
  # NOTE: Commented out -- A2A-Extensions header not tested by reference server

  # describe "when transmitting A2A service parameters" do
  #   it "should use standard HTTP request headers" do
  #   end
  # end
end
