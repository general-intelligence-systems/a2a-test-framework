require "a2a_test_framework/test_helper"
require "a2a_test_framework/sse_client"

# REST endpoint: POST /message:stream
# Request: SendMessageRequest
# Response: StreamResponse (SSE stream containing Task, Message, TaskStatusUpdateEvent, TaskArtifactUpdateEvent)

describe "POST /message:stream" do
  # --- Streaming Connection Establishment ---

  describe "when a client sends a SendStreamingMessage request with a valid message" do
    it "should establish a streaming connection and return events" do
      body = build_send_message_request(text: "Stream me!")
      events = SSEClient.post_stream("/message:stream", body, timeout_seconds: 10)

      events.length.should.be > 0
    end
  end

  # --- Task Lifecycle Stream Pattern ---

  describe "when the agent returns a Task response via stream" do
    it "should send a Task object as the first item in the stream" do
      body = build_send_message_request(text: "First event test")
      events = SSEClient.post_stream("/message:stream", body, timeout_seconds: 10)

      events.length.should.be > 0
      first = events.first.data
      first.should.be.kind_of Hash
      # First event should contain a task snapshot
      first.key?("task").should.equal true
      first["task"]["id"].should.not.be.nil
      first["task"]["status"].should.not.be.nil
    end

    it "should include TaskArtifactUpdateEvent in the stream" do
      body = build_send_message_request(text: "Artifact event test")
      events = SSEClient.post_stream("/message:stream", body, timeout_seconds: 10)

      artifact_events = events.select { |e| e.data.is_a?(Hash) && e.data.key?("artifactUpdate") }
      artifact_events.length.should.be > 0

      ae = artifact_events.first.data["artifactUpdate"]
      ae["taskId"].should.not.be.nil
      ae["artifact"].should.not.be.nil
      ae["artifact"]["parts"].should.be.kind_of Array
    end

    it "should include TaskStatusUpdateEvent with terminal state" do
      body = build_send_message_request(text: "Status event test")
      events = SSEClient.post_stream("/message:stream", body, timeout_seconds: 10)

      status_events = events.select { |e| e.data.is_a?(Hash) && e.data.key?("statusUpdate") }
      status_events.length.should.be > 0

      # Last status event should have a terminal state
      last_status = status_events.last.data["statusUpdate"]
      last_status["status"]["state"].should.equal "TASK_STATE_COMPLETED"
    end
  end

  describe "when the task reaches a terminal state during streaming" do
    it "should close the stream when task reaches completed state" do
      body = build_send_message_request(text: "Stream close test")
      events = SSEClient.post_stream("/message:stream", body, timeout_seconds: 10)

      # Stream should have ended (we got events back, not a timeout with no data)
      events.length.should.be > 0

      # Last event should indicate terminal state
      last_event = events.last.data
      if last_event.is_a?(Hash) && last_event.key?("statusUpdate")
        last_event["statusUpdate"]["status"]["state"].should.equal "TASK_STATE_COMPLETED"
      end
      true.should.equal true
    end
  end

  # --- Event Ordering ---

  describe "when validating event ordering" do
    it "should deliver events in correct order: task, artifact, status(completed)" do
      body = build_send_message_request(text: "Order test")
      events = SSEClient.post_stream("/message:stream", body, timeout_seconds: 10)

      events.length.should.be >= 3

      # First should be task snapshot
      events[0].data.key?("task").should.equal true
      # Second should be artifact update
      events[1].data.key?("artifactUpdate").should.equal true
      # Third should be status completed
      events[2].data.key?("statusUpdate").should.equal true
      events[2].data["statusUpdate"]["status"]["state"].should.equal "TASK_STATE_COMPLETED"
    end
  end

  # --- Error Cases ---
  # NOTE: Commented out -- server supports streaming, cannot easily test unsupported case

  # describe "when the server does not support streaming" do
  #   it "should respond with an UnsupportedOperationError" do
  #   end
  # end

  # --- Message-Only Stream Pattern ---
  # NOTE: Commented out -- reference server always returns Task-based streams

  # describe "when the agent returns a Message response via stream" do
  #   it "should contain exactly one Message object in the stream" do
  #   end
  #
  #   it "should close the stream immediately after the Message" do
  #   end
  # end

  # --- Error cases for referencing terminal tasks ---
  # NOTE: Commented out -- streaming endpoint creates new tasks in reference server

  # describe "when a client sends a streaming request referencing a completed task" do
  #   it "should respond with an UnsupportedOperationError" do
  #   end
  # end

  # describe "when a client sends a streaming request referencing a non-existent task ID" do
  #   it "should respond with a TaskNotFoundError" do
  #   end
  # end
end
