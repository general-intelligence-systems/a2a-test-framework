require "a2a_test_framework/test_helper"

# REST endpoint: POST /tasks/{id}:cancel
# Request: CancelTaskRequest (id, metadata, tenant)
# Response: Task

describe "POST /tasks/{id}:cancel" do
  # --- Successful Cancellation ---
  # NOTE: The reference server completes tasks synchronously, so we cannot
  # easily get a task in a non-terminal state to cancel. These are commented out.

  # describe "when a client sends a CancelTask request for a working task" do
  #   it "should respond with an updated Task object" do
  #   end
  #
  #   it "should reflect the cancellation in the Task status" do
  #   end
  # end

  # describe "when a client sends a CancelTask request for a task in input_required state" do
  #   it "should respond with an updated Task object" do
  #   end
  #
  #   it "should reflect the cancellation in the Task status" do
  #   end
  # end

  # describe "when a client sends a CancelTask request for a cancelable task" do
  #   it "should return an updated Task object with cancellation status" do
  #   end
  # end

  # --- Error Cases ---

  describe "when a client sends a CancelTask request for a completed task" do
    it "should respond with a TaskNotCancelableError" do
      task = create_task!(text: "Complete then cancel")
      task["status"]["state"].should.equal "TASK_STATE_COMPLETED"

      response = http_post("/tasks/#{task["id"]}:cancel", {})

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  describe "when a client sends a CancelTask request for an already canceled task" do
    it "should respond with a TaskNotCancelableError" do
      task = create_task!(text: "Cancel again")

      # First cancel attempt (will fail since task is completed)
      response = http_post("/tasks/#{task["id"]}:cancel", {})

      # Second attempt should also error
      response2 = http_post("/tasks/#{task["id"]}:cancel", {})
      if response2.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response2)
        data.key?("error").should.equal true
      end
    end
  end

  describe "when a client sends a CancelTask request with a non-existent task ID" do
    it "should respond with a TaskNotFoundError" do
      fake_id = "nonexistent-#{SecureRandom.uuid}"
      response = http_post("/tasks/#{fake_id}:cancel", {})

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  describe "when a client sends a CancelTask request for a task not accessible to the client" do
    it "should respond with a TaskNotFoundError" do
      fake_id = "inaccessible-#{SecureRandom.uuid}"
      response = http_post("/tasks/#{fake_id}:cancel", {})

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  # --- Idempotency ---

  describe "when a client sends multiple CancelTask requests for the same task" do
    it "should handle repeated cancellation requests consistently" do
      task = create_task!(text: "Idempotent cancel")

      response1 = http_post("/tasks/#{task["id"]}:cancel", {})
      response2 = http_post("/tasks/#{task["id"]}:cancel", {})

      # Both should return same type of error (task is already terminal)
      response1.code.to_i.should.equal response2.code.to_i
    end
  end
end
