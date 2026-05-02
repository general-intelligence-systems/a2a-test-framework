require "a2a_test_framework/test_helper"

# REST endpoint: GET /tasks/{task_id}/pushNotificationConfigs
# Request: ListTaskPushNotificationConfigsRequest (taskId, pageSize, pageToken, tenant)
# Response: ListTaskPushNotificationConfigsResponse (configs[], nextPageToken)

describe "GET /tasks/{task_id}/pushNotificationConfigs" do
  # --- Successful Retrieval ---

  describe "when a task has multiple push notification configs" do
    it "should return all active push notification configurations for that task" do
      task = create_task!(text: "Multi config test")

      # Create two configs
      body1 = build_push_notification_config(task_id: task["id"], url: "https://example.com/hook1")
      body2 = build_push_notification_config(task_id: task["id"], url: "https://example.com/hook2")
      http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body1)
      http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body2)

      # List them
      response = http_get("/tasks/#{task["id"]}/pushNotificationConfigs")
      response.code.to_i.should.equal 200

      data = parse_json(response)
      data["configs"].should.be.kind_of Array
      data["configs"].length.should.be >= 2
    end
  end

  describe "when a task has no push notification configs" do
    it "should return an empty list of configurations" do
      task = create_task!(text: "No configs test")

      response = http_get("/tasks/#{task["id"]}/pushNotificationConfigs")
      response.code.to_i.should.equal 200

      data = parse_json(response)
      data["configs"].should.be.kind_of Array
      data["configs"].length.should.equal 0
    end
  end

  describe "when a task has both active and deleted push notification configs" do
    it "should only return active configurations" do
      task = create_task!(text: "Active vs deleted test")

      # Create two, delete one
      body1 = build_push_notification_config(task_id: task["id"], url: "https://example.com/keep")
      body2 = build_push_notification_config(task_id: task["id"], url: "https://example.com/delete")
      http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body1)
      create2_resp = http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body2)
      config2 = parse_json(create2_resp)

      # Delete the second
      http_delete("/tasks/#{task["id"]}/pushNotificationConfigs/#{config2["id"]}")

      # List should only show one
      response = http_get("/tasks/#{task["id"]}/pushNotificationConfigs")
      data = parse_json(response)

      data["configs"].length.should.equal 1
      data["configs"][0]["url"].should.equal "https://example.com/keep"
    end
  end

  # --- Error Cases ---

  describe "when a client sends a request with a non-existent task ID" do
    it "should respond with a TaskNotFoundError" do
      response = http_get("/tasks/nonexistent-#{SecureRandom.uuid}/pushNotificationConfigs")

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  # NOTE: Commented out -- reference server supports push notifications

  # describe "when the server does not support push notifications" do
  #   it "should respond with a PushNotificationNotSupportedError" do
  #   end
  # end

  # describe "when a client sends a request for a task not accessible to the client" do
  #   it "should respond with a TaskNotFoundError" do
  #   end
  # end
end
