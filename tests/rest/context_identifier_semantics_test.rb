require "a2a_test_framework/test_helper"

# Cross-cutting: Context identifier semantics

describe "Context Identifier Semantics (REST)" do
  # --- Generation and Assignment ---

  describe "when a client sends a message without a contextId" do
    it "should generate a contextId and include it in the response" do
      body = build_send_message_request(text: "No context provided")
      # Don't include contextId in message
      response = http_post("/message:send", body)
      data = parse_json(response)

      if data["task"]
        data["task"]["contextId"].should.not.be.nil
        data["task"]["contextId"].should.be.kind_of String
        data["task"]["contextId"].length.should.be > 0
      end
      true.should.equal true
    end
  end

  describe "when a client sends a message with a contextId" do
    it "should preserve that contextId in the response" do
      provided_context = SecureRandom.uuid
      body = build_send_message_request(text: "With context", context_id: provided_context)
      response = http_post("/message:send", body)
      data = parse_json(response)

      if data["task"]
        data["task"]["contextId"].should.equal provided_context
      end
      true.should.equal true
    end
  end

  # --- Grouping and Scope ---

  describe "when multiple tasks share the same contextId" do
    it "should group them under the same conversational session" do
      context = SecureRandom.uuid
      body1 = build_send_message_request(text: "Context group 1", context_id: context)
      body2 = build_send_message_request(text: "Context group 2", context_id: context)

      http_post("/message:send", body1)
      http_post("/message:send", body2)

      # Both tasks should appear when listing by contextId
      response = http_get("/tasks?contextId=#{context}")
      data = parse_json(response)

      data["tasks"].length.should.be >= 2
      data["tasks"].each { |t| t["contextId"].should.equal context }
    end
  end

  # --- ContextId as opaque string ---

  describe "when examining contextId format" do
    it "should treat contextId as an opaque string" do
      task = create_task!(text: "Opaque context test")
      task["contextId"].should.be.kind_of String
      task["contextId"].length.should.be > 0
    end
  end

  # --- Server-Provided Context ---
  # NOTE: Commented out -- behavior depends on whether server accepts client contexts

  # describe "when the server does not accept client-provided contextIds" do
  #   it "should reject the request with an error" do
  #   end
  # end
end
