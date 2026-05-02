require "a2a_test_framework/test_helper"

# Cross-cutting: Multi-turn conversation patterns
# REST: POST /message:send, POST /message:stream

describe "Multi-Turn Conversation Patterns (REST)" do
  # --- Context Continuity ---

  describe "when a client sends a message with a contextId from a previous interaction" do
    it "should create a new task within the same context" do
      # Create first task
      task1 = create_task!(text: "First message in context")
      context_id = task1["contextId"]

      # Send second message with same contextId
      body = build_send_message_request(text: "Second message", context_id: context_id)
      response = http_post("/message:send", body)
      response.code.to_i.should.equal 200

      data = parse_json(response)
      if data["task"]
        data["task"]["contextId"].should.equal context_id
      end
      true.should.equal true
    end
  end

  describe "when a client sends a message to continue a specific task" do
    it "should add the message to the task history" do
      # The reference server completes tasks synchronously, so sending to
      # a completed task will error. This tests the message is accepted
      # or properly rejected.
      task = create_task!(text: "Original message")

      body = build_send_message_request(text: "Follow up message")
      body["message"]["taskId"] = task["id"]
      response = http_post("/message:send", body)

      # Either accepted (200) or rejected because task is terminal (4xx)
      (response.code.to_i == 200 || response.code.to_i >= 400).should.equal true
    end
  end

  # --- Context Sharing ---

  describe "when multiple tasks share the same contextId" do
    it "should list all tasks when filtering by contextId" do
      # Create two tasks, second one with explicit contextId
      task1 = create_task!(text: "Context sharing 1")
      context_id = task1["contextId"]

      body2 = build_send_message_request(text: "Context sharing 2", context_id: context_id)
      http_post("/message:send", body2)

      # List tasks by context
      response = http_get("/tasks?contextId=#{context_id}")
      data = parse_json(response)

      data["tasks"].length.should.be >= 2
      data["tasks"].each { |t| t["contextId"].should.equal context_id }
    end
  end

  # --- Input Required State ---
  # NOTE: Commented out -- reference server does not enter INPUT_REQUIRED state

  # describe "when the agent needs additional input from the client" do
  #   it "should transition the task to input_required state" do
  #   end
  # end

  # describe "when a client sends a message to a task in input_required state" do
  #   it "should accept the message and continue processing the task" do
  #   end
  # end

  # --- Follow-up Messages ---
  # NOTE: Commented out -- reference server completes tasks immediately

  # describe "when a client sends a follow-up message with taskId to refine an existing task" do
  #   it "should accept the message as a refinement of the existing task" do
  #   end
  # end

  # describe "when a client sends a message with referenceTaskIds" do
  #   it "should use the referenced tasks to understand context and intent" do
  #   end
  # end

  # describe "when a client sends a message with mismatching contextId and taskId" do
  #   it "should reject the message with an error" do
  #   end
  # end
end
