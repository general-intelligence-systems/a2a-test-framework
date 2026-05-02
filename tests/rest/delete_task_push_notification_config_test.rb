require "a2a_test_framework/test_helper"

# REST endpoint: DELETE /tasks/{task_id}/pushNotificationConfigs/{id}
# Request: DeleteTaskPushNotificationConfigRequest (taskId, id, tenant)
# Response: google.protobuf.Empty

describe "DELETE /tasks/{task_id}/pushNotificationConfigs/{id}" do
  # --- Successful Deletion ---

  describe "when a client deletes an existing push notification config" do
    it "should respond with a successful status" do
      task = create_task!(text: "Delete config test")
      body = build_push_notification_config(task_id: task["id"], url: "https://example.com/to-delete")
      create_resp = http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body)
      config = parse_json(create_resp)

      response = http_delete("/tasks/#{task["id"]}/pushNotificationConfigs/#{config["id"]}")
      response.code.to_i.should.be < 400
    end

    it "should cause subsequent GetPushNotificationConfig requests to fail" do
      task = create_task!(text: "Delete then get test")
      body = build_push_notification_config(task_id: task["id"], url: "https://example.com/delete-verify")
      create_resp = http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body)
      config = parse_json(create_resp)

      # Delete it
      http_delete("/tasks/#{task["id"]}/pushNotificationConfigs/#{config["id"]}")

      # Try to get it -- should fail
      get_response = http_get("/tasks/#{task["id"]}/pushNotificationConfigs/#{config["id"]}")
      if get_response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(get_response)
        data.key?("error").should.equal true
      end
    end

    it "should remove config from the list" do
      task = create_task!(text: "Delete from list test")
      body = build_push_notification_config(task_id: task["id"], url: "https://example.com/list-delete")
      create_resp = http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body)
      config = parse_json(create_resp)

      # Delete
      http_delete("/tasks/#{task["id"]}/pushNotificationConfigs/#{config["id"]}")

      # List should be empty
      list_resp = http_get("/tasks/#{task["id"]}/pushNotificationConfigs")
      list_data = parse_json(list_resp)
      list_data["configs"].length.should.equal 0
    end
  end

  # --- Idempotency ---

  describe "when a client sends multiple delete requests for the same config" do
    it "should handle repeated deletion without error" do
      task = create_task!(text: "Idempotent delete test")
      body = build_push_notification_config(task_id: task["id"], url: "https://example.com/idem-delete")
      create_resp = http_post("/tasks/#{task["id"]}/pushNotificationConfigs", body)
      config = parse_json(create_resp)

      # Delete twice
      response1 = http_delete("/tasks/#{task["id"]}/pushNotificationConfigs/#{config["id"]}")
      response2 = http_delete("/tasks/#{task["id"]}/pushNotificationConfigs/#{config["id"]}")

      # Both should succeed (or second returns not-found gracefully)
      response1.code.to_i.should.be < 500
      response2.code.to_i.should.be < 500
    end
  end

  # --- Error Cases ---

  describe "when a client sends a request with a non-existent task ID" do
    it "should respond with an error" do
      response = http_delete("/tasks/nonexistent-#{SecureRandom.uuid}/pushNotificationConfigs/fake-id")

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  # NOTE: Commented out -- server supports push notifications

  # describe "when the server does not support push notifications" do
  #   it "should respond with a PushNotificationNotSupportedError" do
  #   end
  # end

  # NOTE: Commented out -- requires webhook delivery verification

  # describe "when a task changes status after config deletion" do
  #   it "should not send notifications to the previously configured webhook URL" do
  #   end
  # end
end
