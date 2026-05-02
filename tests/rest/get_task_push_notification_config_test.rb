require "a2a_test_framework/test_helper"

# REST endpoint: GET /tasks/{task_id}/pushNotificationConfigs/{id}
# Request: GetTaskPushNotificationConfigRequest (taskId, id, tenant)
# Response: TaskPushNotificationConfig

describe "GET /tasks/{task_id}/pushNotificationConfigs/{id}" do
  # --- Successful Retrieval ---

  describe "when a client retrieves an existing push notification config" do
    it "should respond with a PushNotificationConfig object" do
      task = create_task!(text: "Get config test")
      # Create a config first
      body = build_push_notification_config(
        task_id: task["id"],
        url: "https://example.com/get-hook",
        token: "get-token"
      )
      create_response = http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body)
      created = parse_json(create_response)
      config_id = created["id"]

      # Now retrieve it
      response = http_get("/tasks/#{task["id"]}/pushNotificationConfigs/#{config_id}")
      response.code.to_i.should.equal 200

      data = parse_json(response)
      data["id"].should.equal config_id
      data["url"].should.equal "https://example.com/get-hook"
    end

    it "should include the webhook URL in the configuration details" do
      task = create_task!(text: "URL check test")
      body = build_push_notification_config(
        task_id: task["id"],
        url: "https://example.com/url-check"
      )
      create_response = http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body)
      created = parse_json(create_response)

      response = http_get("/tasks/#{task["id"]}/pushNotificationConfigs/#{created["id"]}")
      data = parse_json(response)

      data["url"].should.equal "https://example.com/url-check"
    end
  end

  # --- Error Cases ---

  describe "when a client requests a non-existent config ID" do
    it "should respond with an error" do
      task = create_task!(text: "Missing config test")
      response = http_get("/tasks/#{task["id"]}/pushNotificationConfigs/nonexistent-#{SecureRandom.uuid}")

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  # NOTE: Commented out -- reference server doesn't implement auth

  # describe "when the server does not support push notifications" do
  #   it "should respond with a PushNotificationNotSupportedError" do
  #   end
  # end

  # describe "when a client lacks access to the configuration" do
  #   it "should respond with an error" do
  #   end
  # end
end
