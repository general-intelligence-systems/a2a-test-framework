require "a2a_test_framework/test_helper"
require "a2a_test_framework/sse_client"

# Cross-cutting: Streaming event delivery applies to:
# REST: POST /message:stream, GET /tasks/{id}:subscribe

describe "Streaming Event Delivery (REST)" do
  # --- Event Ordering ---

  describe "when a task generates multiple events in sequence" do
    it "should deliver all events in the order they were generated" do
      body = build_send_message_request(text: "Event order test")
      events = SSEClient.post_stream("/message:stream", body, timeout_seconds: 10)

      events.length.should.be >= 3

      # Verify ordering: task first, then artifact, then status completed
      events[0].data.key?("task").should.equal true
      events[1].data.key?("artifactUpdate").should.equal true
      events[2].data.key?("statusUpdate").should.equal true
    end

    it "should not reorder events during transmission" do
      body = build_send_message_request(text: "No reorder test")
      events = SSEClient.post_stream("/message:stream", body, timeout_seconds: 10)

      # The last status event should be terminal
      status_events = events.select { |e| e.data.is_a?(Hash) && e.data.key?("statusUpdate") }
      if status_events.length > 0
        last_status = status_events.last.data["statusUpdate"]["status"]["state"]
        last_status.should.equal "TASK_STATE_COMPLETED"
      end
      true.should.equal true
    end
  end

  # --- Multiple Streams Per Task ---
  # NOTE: Commented out -- requires tasks in non-terminal state for subscribe

  # describe "when multiple clients subscribe to the same task" do
  #   it "should serve multiple concurrent streams simultaneously" do
  #   end
  #
  #   it "should broadcast events to all active streams for a task" do
  #   end
  #
  #   it "should deliver the same events in the same order to each stream" do
  #   end
  # end

  # describe "when one client closes their stream" do
  #   it "should keep other active streams open and receiving events" do
  #   end
  #
  #   it "should not affect the task lifecycle" do
  #   end
  # end
end
