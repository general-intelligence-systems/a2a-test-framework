#!/usr/bin/env ruby
# frozen_string_literal: true

# Parses a2a.proto and a2a.json to extract every endpoint for both
# the gRPC and REST protocol bindings, outputting one file per endpoint
# into ./endpoints/grpc/ and ./endpoints/rest/

require 'json'
require 'fileutils'

PROTO_FILE = File.join(__dir__, 'a2a.proto')
JSON_FILE = File.join(__dir__, 'a2a.json')
OUTPUT_DIR = File.join(__dir__, 'endpoints')

# --- Parse a2a.proto ---

proto_content = File.read(PROTO_FILE)
lines = proto_content.lines

# State machine parser for extracting RPC blocks
rpc_blocks = []
i = 0
while i < lines.size
  line = lines[i]

  if line =~ /^\s*rpc\s+(\w+)\((\w+)\)\s+returns\s+\(([^)]+)\)/
    rpc_name = $1
    request_type = $2
    response_type = $3.strip

    # Gather preceding comment lines as description
    comment_lines = []
    j = i - 1
    while j >= 0 && lines[j] =~ /^\s*\/\//
      comment_lines.unshift(lines[j].sub(/^\s*\/\/\s?/, '').rstrip)
      j -= 1
    end
    description = comment_lines.reject(&:empty?).reject { |l| l.start_with?('(--') }.join(' ').strip

    # Gather the body between braces
    body = ''
    brace_depth = 0
    started = false
    k = i
    while k < lines.size
      lines[k].each_char do |c|
        if c == '{'
          brace_depth += 1
          started = true
        elsif c == '}'
          brace_depth -= 1
        end
      end
      body += lines[k]
      break if started && brace_depth == 0
      k += 1
    end

    rpc_blocks << {
      name: rpc_name,
      request: request_type,
      response: response_type,
      description: description,
      body: body
    }

    i = k + 1
  else
    i += 1
  end
end

# --- Parse a2a.json ---

json_schema = JSON.parse(File.read(JSON_FILE))
definitions = json_schema['definitions'] || {}

# Build a lookup from type name (e.g. "SendMessageRequest") to its schema
# The JSON keys use spaces in titles like "Send Message Request"
# We need to map proto type names to JSON definition keys
def proto_type_to_json_key(proto_type, definitions)
  # Try exact title match by converting CamelCase to spaced words
  spaced = proto_type.gsub(/([a-z])([A-Z])/, '\1 \2').gsub(/([A-Z]+)([A-Z][a-z])/, '\1 \2')
  definitions.each do |key, schema|
    return key if schema['title'] == spaced
  end
  # Try looser match
  definitions.each do |key, schema|
    title_compressed = (schema['title'] || '').gsub(/\s+/, '')
    return key if title_compressed == proto_type
  end
  nil
end

# --- Convert RPC name to snake_case filename ---

def to_snake(name)
  name.gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .downcase
end

# --- Build endpoint data ---

endpoints = rpc_blocks.map do |block|
  streaming = block[:response].include?('stream')
  response_type = block[:response].gsub(/\bstream\s+/, '').strip

  # Extract HTTP annotations
  http_method = nil
  paths = []

  block[:body].scan(/(get|post|put|delete|patch):\s*"([^"]+)"/) do |method, path|
    http_method ||= method.upcase
    paths << path.gsub(/=\*/, '') # clean {id=*} -> {id}
  end

  primary_path = paths.reject { |p| p.include?('{tenant}') }.first
  tenant_paths = paths.select { |p| p.include?('{tenant}') }

  # Lookup JSON schemas for request and response
  req_key = proto_type_to_json_key(block[:request], definitions)
  resp_key = proto_type_to_json_key(response_type, definitions)

  request_schema = req_key ? definitions[req_key] : nil
  response_schema = resp_key ? definitions[resp_key] : nil

  {
    rpc_name: block[:name],
    description: block[:description],
    http_method: http_method,
    primary_path: primary_path,
    tenant_paths: tenant_paths,
    all_paths: paths,
    request_type: block[:request],
    response_type: response_type,
    streaming: streaming,
    request_schema: request_schema,
    response_schema: response_schema
  }
end

# --- Write output ---

grpc_dir = File.join(OUTPUT_DIR, 'grpc')
rest_dir = File.join(OUTPUT_DIR, 'rest')
FileUtils.mkdir_p(grpc_dir)
FileUtils.mkdir_p(rest_dir)

endpoints.each do |ep|
  filename = to_snake(ep[:rpc_name]) + '.json'

  # --- gRPC endpoint file ---
  grpc_data = {
    protocol: 'gRPC',
    service: 'A2AService',
    method: ep[:rpc_name],
    description: ep[:description],
    request_type: ep[:request_type],
    response_type: ep[:response_type],
    client_streaming: false,
    server_streaming: ep[:streaming]
  }
  File.write(File.join(grpc_dir, filename), JSON.pretty_generate(grpc_data))
  puts "  grpc/#{filename}"

  # --- REST endpoint file ---
  rest_data = {
    protocol: 'REST (HTTP+JSON)',
    http_method: ep[:http_method],
    path: ep[:primary_path],
    tenant_path: ep[:tenant_paths].first,
    description: ep[:description],
    streaming: ep[:streaming],
    request: {
      type: ep[:request_type],
      schema: ep[:request_schema]
    },
    response: {
      type: ep[:response_type],
      schema: ep[:response_schema]
    }
  }
  File.write(File.join(rest_dir, filename), JSON.pretty_generate(rest_data))
  puts "  rest/#{filename}"
end

puts "\nDone! Generated #{endpoints.size} gRPC + #{endpoints.size} REST endpoint files (#{endpoints.size * 2} total)."
puts "Output: #{OUTPUT_DIR}/{grpc,rest}/"
