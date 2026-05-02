# frozen_string_literal: true

require "bundler/setup"
require "scampi"
require "net/http"
require "json"
require "uri"
require "securerandom"
require "a2a"

BASE_URL = ENV.fetch("A2A_BASE_URL", "http://localhost:9292")

# --- HTTP Helpers -----------------------------------------------------------

def http_post(path, body, headers: {})
  uri = URI("#{BASE_URL}#{path}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == "https"
  http.read_timeout = 30
  request = Net::HTTP::Post.new(uri.path)
  request["Content-Type"] = "application/json"
  headers.each { |k, v| request[k] = v }
  request.body = JSON.generate(body)
  http.request(request)
end

def http_get(path, headers: {})
  uri = URI("#{BASE_URL}#{path}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == "https"
  http.read_timeout = 30
  request = Net::HTTP::Get.new(uri.request_uri)
  headers.each { |k, v| request[k] = v }
  http.request(request)
end

def http_delete(path, headers: {})
  uri = URI("#{BASE_URL}#{path}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == "https"
  http.read_timeout = 30
  request = Net::HTTP::Delete.new(uri.path)
  headers.each { |k, v| request[k] = v }
  http.request(request)
end

def parse_json(response)
  JSON.parse(response.body)
end

# --- Request Builders (using A2A Schema objects) ----------------------------

def build_send_message_request(text: "Hello, agent", task_id: nil, context_id: nil, configuration: nil, metadata: nil)
  message = {
    "messageId" => SecureRandom.uuid,
    "role" => "ROLE_USER",
    "parts" => [{ "text" => text }]
  }
  message["taskId"] = task_id if task_id
  message["contextId"] = context_id if context_id

  A2A::Schema["Send Message Request"].new(
    message: message,
    configuration: configuration,
    metadata: metadata
  ).to_h
end

def build_get_task_request(id:, history_length: nil)
  A2A::Schema["Get Task Request"].new(
    id: id,
    history_length: history_length
  ).to_h
end

def build_list_tasks_request(context_id: nil, status: nil, page_size: nil, page_token: nil, history_length: nil, include_artifacts: nil)
  A2A::Schema["List Tasks Request"].new(
    context_id: context_id,
    status: status,
    page_size: page_size,
    page_token: page_token,
    history_length: history_length,
    include_artifacts: include_artifacts
  ).to_h
end

def build_cancel_task_request(id:, metadata: nil)
  A2A::Schema["Cancel Task Request"].new(
    id: id,
    metadata: metadata
  ).to_h
end

def build_subscribe_to_task_request(id:)
  A2A::Schema["Subscribe To Task Request"].new(id: id).to_h
end

def build_push_notification_config(task_id:, url: "https://example.com/webhook", token: nil, authentication: nil)
  A2A::Schema["Task Push Notification Config"].new(
    task_id: task_id,
    url: url,
    token: token,
    authentication: authentication
  ).to_h
end

def build_get_push_notification_config_request(id:, task_id:)
  A2A::Schema["Get Task Push Notification Config Request"].new(
    id: id,
    task_id: task_id
  ).to_h
end

def build_list_push_notification_configs_request(task_id:, page_size: nil, page_token: nil)
  A2A::Schema["List Task Push Notification Configs Request"].new(
    task_id: task_id,
    page_size: page_size,
    page_token: page_token
  ).to_h
end

def build_delete_push_notification_config_request(id:, task_id:)
  A2A::Schema["Delete Task Push Notification Config Request"].new(
    id: id,
    task_id: task_id
  ).to_h
end

# --- Lifecycle Helpers ------------------------------------------------------

# Sends a message and returns the task hash from the response.
def create_task!(text: "Hello, agent")
  body = build_send_message_request(text: text)
  response = http_post("/message:send", body)
  raise "Failed to create task: HTTP #{response.code}" unless response.code.to_i == 200
  data = parse_json(response)
  raise "No task in response" unless data["task"]
  data["task"]
end

# Retrieves a task by ID.
def get_task!(id)
  response = http_get("/tasks/#{id}")
  raise "Failed to get task: HTTP #{response.code}" unless response.code.to_i == 200
  parse_json(response)
end
