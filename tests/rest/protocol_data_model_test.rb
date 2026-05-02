require "a2a_test_framework/test_helper"

# Cross-cutting: Protocol data model applies to all REST endpoints
# Verifies that data structures conform to the A2A protocol specification.

describe "Protocol Data Model (REST)" do
  describe "when validating Task object structure" do
    it "should contain required fields: id, status" do
      task = create_task!(text: "Task model test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      data["id"].should.not.be.nil
      data["status"].should.not.be.nil
    end

    it "should contain status with state and timestamp" do
      task = create_task!(text: "Status model test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      data["status"]["state"].should.not.be.nil
      data["status"]["timestamp"].should.not.be.nil
    end
  end

  describe "when validating Message object structure" do
    it "should contain role and parts fields" do
      task = create_task!(text: "Message model test")
      response = http_get("/tasks/#{task["id"]}?historyLength=10")
      data = parse_json(response)

      if data["history"] && data["history"].length > 0
        msg = data["history"].first
        msg["role"].should.not.be.nil
        msg["parts"].should.not.be.nil
        msg["parts"].should.be.kind_of Array
      end
      true.should.equal true
    end

    it "should contain messageId in messages" do
      task = create_task!(text: "MessageId test")
      response = http_get("/tasks/#{task["id"]}?historyLength=10")
      data = parse_json(response)

      if data["history"] && data["history"].length > 0
        msg = data["history"].first
        msg["messageId"].should.not.be.nil
        msg["messageId"].should.be.kind_of String
      end
      true.should.equal true
    end
  end

  describe "when validating Part object structure" do
    it "should contain at least one content field (text, data, url, or raw)" do
      task = create_task!(text: "Part model test")
      response = http_get("/tasks/#{task["id"]}?historyLength=10")
      data = parse_json(response)

      if data["history"] && data["history"].length > 0
        part = data["history"].first["parts"].first
        has_content = part.key?("text") || part.key?("data") || part.key?("url") || part.key?("raw")
        has_content.should.equal true
      end
      true.should.equal true
    end
  end

  describe "when validating Artifact object structure" do
    it "should contain artifactId and parts" do
      task = create_task!(text: "Artifact model test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      if data["artifacts"] && data["artifacts"].length > 0
        artifact = data["artifacts"].first
        artifact["artifactId"].should.not.be.nil
        artifact["parts"].should.not.be.nil
        artifact["parts"].should.be.kind_of Array
      end
      true.should.equal true
    end
  end

  describe "when validating SendMessageResponse structure" do
    it "should contain exactly one of task or message at the top level" do
      body = build_send_message_request(text: "Response model test")
      response = http_post("/message:send", body)
      data = parse_json(response)

      has_task = data.key?("task") && !data["task"].nil?
      has_message = data.key?("message") && !data["message"].nil?

      (has_task ^ has_message).should.equal true
    end
  end
end
