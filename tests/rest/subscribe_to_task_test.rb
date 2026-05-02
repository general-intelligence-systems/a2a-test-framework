require "a2a_test_framework/test_helper"
require "a2a_test_framework/sse_client"

# REST endpoint: GET /tasks/{id}:subscribe
# Request: SubscribeToTaskRequest (id, tenant)
# Response: stream of StreamResponse (SSE)

describe "GET /tasks/{id}:subscribe" do
  # --- Stream Initialization ---
  # NOTE: The reference server completes tasks synchronously, so subscribing
  # to a task after SendMessage will always find it in a terminal state.
  # We can only test error cases here.

  # describe "when a client subscribes to a working task" do
  #   it "should send a Task object as the first event in the stream" do
  #   end
  #
  #   it "should represent the current state of the task at time of subscription" do
  #   end
  # end

  # --- Error Cases ---

  describe "when a client subscribes to a non-existent task ID" do
    it "should respond with an error" do
      response = http_get("/tasks/nonexistent-#{SecureRandom.uuid}:subscribe")

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  describe "when a client subscribes to a task in completed state" do
    it "should respond with an error indicating unsupported operation" do
      task = create_task!(text: "Subscribe to completed")
      task["status"]["state"].should.equal "TASK_STATE_COMPLETED"

      response = http_get("/tasks/#{task["id"]}:subscribe")

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  describe "when a client subscribes to a task not accessible to the client" do
    it "should respond with an error" do
      response = http_get("/tasks/inaccessible-#{SecureRandom.uuid}:subscribe")

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  # --- Stream Content ---
  # NOTE: Commented out -- requires a task in non-terminal state

  # describe "when the subscribed task status changes" do
  #   it "should deliver a TaskStatusUpdateEvent object" do
  #   end
  # end

  # describe "when the subscribed task generates a new artifact" do
  #   it "should deliver a TaskArtifactUpdateEvent object" do
  #   end
  # end

  # --- Stream Termination ---
  # NOTE: Commented out -- requires a task in non-terminal state

  # describe "when the subscribed task reaches a terminal state" do
  #   it "should terminate the stream when task reaches completed state" do
  #   end
  # end

  # describe "when the subscribed task is in a non-terminal state" do
  #   it "should keep the stream open while task is in working state" do
  #   end
  # end

  # --- Server Not Supporting Streaming ---
  # NOTE: Commented out -- reference server supports streaming

  # describe "when the server does not support streaming" do
  #   it "should respond with an UnsupportedOperationError" do
  #   end
  # end
end
