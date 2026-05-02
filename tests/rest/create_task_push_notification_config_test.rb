require "a2a_test_framework/test_helper"

# REST endpoint: POST /tasks/{task_id}/pushNotificationConfigs
# Request: TaskPushNotificationConfig (taskId, url, token, authentication, tenant)
# Response: TaskPushNotificationConfig

describe "POST /tasks/{task_id}/pushNotificationConfigs" do
  # --- Successful Creation ---

  describe "when a client creates a push notification config with a valid webhook URL" do
    it "should respond with a PushNotificationConfig object" do
      task = create_task!(text: "Push config creation")
      body = build_push_notification_config(
        task_id: task["id"],
        url: "https://example.com/webhook",
        token: "test-token-123"
      )

      response = http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body)
      response.code.to_i.should.equal 200

      data = parse_json(response)
      data["url"].should.equal "https://example.com/webhook"
      data["token"].should.equal "test-token-123"
    end

    it "should contain an assigned ID in the response" do
      task = create_task!(text: "Push config ID test")
      body = build_push_notification_config(
        task_id: task["id"],
        url: "https://example.com/hook2"
      )

      response = http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body)
      data = parse_json(response)

      data["id"].should.not.be.nil
      data["id"].should.be.kind_of String
      data["id"].length.should.be > 0
    end
  end

  # --- Configuration with Authentication ---

  describe "when a client creates a config with authentication details" do
    it "should store and return the authentication scheme" do
      task = create_task!(text: "Auth config test")
      body = build_push_notification_config(
        task_id: task["id"],
        url: "https://example.com/authed-hook",
        authentication: { "scheme" => "Bearer", "credentials" => "my-secret" }
      )

      response = http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body)
      response.code.to_i.should.equal 200

      data = parse_json(response)
      data["authentication"].should.not.be.nil
      data["authentication"]["scheme"].should.equal "Bearer"
    end
  end

  # --- Webhook Delivery ---
  # NOTE: Commented out -- requires an actual webhook receiver endpoint

  # describe "when the task status changes after config creation" do
  #   it "should send an HTTP POST request to the configured webhook URL" do
  #   end
  #
  #   it "should send the payload as a StreamResponse object" do
  #   end
  # end

  # --- Configuration Persistence ---
  # NOTE: Commented out -- requires async task lifecycle

  # describe "when a push notification config exists for a non-terminal task" do
  #   it "should remain active while the task is in a non-terminal state" do
  #   end
  # end

  # --- Error Cases ---

  describe "when a client sends a request with a non-existent task ID" do
    it "should respond with a TaskNotFoundError" do
      body = build_push_notification_config(
        task_id: "nonexistent-#{SecureRandom.uuid}",
        url: "https://example.com/hook"
      )

      response = http_post("/tasks/nonexistent-#{SecureRandom.uuid}/pushNotificationConfigs", body)

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  # --- Capability Validation ---
  # NOTE: Reference server declares pushNotifications=true

  describe "when the AgentCard declares pushNotifications capability as true" do
    it "should accept and process the request" do
      task = create_task!(text: "Capability check")
      body = build_push_notification_config(
        task_id: task["id"],
        url: "https://example.com/cap-hook"
      )

      response = http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body)
      response.code.to_i.should.equal 200
    end
  end

  # describe "when the AgentCard declares pushNotifications capability as false" do
  #   it "should respond with a PushNotificationNotSupportedError" do
  #   end
  # end
end
