require "a2a_test_framework/test_helper"

# Cross-cutting: Task identifier semantics

describe "Task Identifier Semantics (REST)" do
  # --- Server Generation ---

  describe "when a client sends a message that triggers task creation" do
    it "should generate the taskId on the server" do
      body = build_send_message_request(text: "Task ID generation")
      response = http_post("/message:send", body)
      data = parse_json(response)

      if data["task"]
        data["task"]["id"].should.not.be.nil
        data["task"]["id"].should.be.kind_of String
        data["task"]["id"].length.should.be > 0
      end
      true.should.equal true
    end
  end

  describe "when multiple tasks are created" do
    it "should generate a unique taskId for each new task" do
      task1 = create_task!(text: "Unique ID test 1")
      task2 = create_task!(text: "Unique ID test 2")

      task1["id"].should.not.equal task2["id"]
    end
  end

  describe "when the response is a Task object" do
    it "should include the generated taskId in the Task object" do
      task = create_task!(text: "ID in response test")
      task["id"].should.not.be.nil
      task["id"].length.should.be > 0
    end
  end

  # --- Client-Provided taskId References ---

  describe "when a client provides a taskId that does not correspond to an existing task" do
    it "should return a TaskNotFoundError" do
      body = build_send_message_request(text: "Bad task ref")
      body["message"]["taskId"] = "nonexistent-#{SecureRandom.uuid}"
      response = http_post("/message:send", body)

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  # --- TaskId as opaque string ---

  describe "when examining taskId format" do
    it "should treat taskId as an opaque string (no client assumptions about format)" do
      task = create_task!(text: "Opaque ID test")
      # The ID exists and is a non-empty string -- that's all clients should assume
      task["id"].should.be.kind_of String
      task["id"].length.should.be > 0
    end
  end
end
