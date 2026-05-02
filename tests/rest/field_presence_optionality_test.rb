require "a2a_test_framework/test_helper"

# Cross-cutting: Field presence and optionality applies to all REST endpoints

describe "Field Presence and Optionality (REST)" do
  # --- Required Fields ---

  describe "when a client sends a message with all required fields present" do
    it "should accept the message as valid" do
      body = build_send_message_request(text: "All fields present")
      response = http_post("/message:send", body)
      response.code.to_i.should.equal 200
    end
  end

  describe "when a client sends a message with a required field missing" do
    it "should reject the message with an error" do
      # Send request without message field (required)
      response = http_post("/message:send", {})
      response.code.to_i.should.be >= 400
    end
  end

  describe "when a client sends a message with parts as empty array" do
    it "should reject or handle gracefully" do
      body = {
        "message" => {
          "messageId" => SecureRandom.uuid,
          "role" => "ROLE_USER",
          "parts" => []
        }
      }
      response = http_post("/message:send", body)
      # Server should either reject (400) or handle gracefully
      (response.code.to_i >= 200 && response.code.to_i < 500).should.equal true
    end
  end

  # --- Unrecognized Fields ---

  describe "when a client sends a request with an unrecognized extra field" do
    it "should ignore the unrecognized field and process normally" do
      body = build_send_message_request(text: "Extra field test")
      body["unknownExtraField"] = "should be ignored"
      body["anotherUnknown"] = 42

      response = http_post("/message:send", body)
      response.code.to_i.should.equal 200
    end
  end

  describe "when a client sends fields from a future protocol version" do
    it "should process the request based on known fields" do
      body = build_send_message_request(text: "Future compat test")
      body["futureField_v99"] = { "data" => "from the future" }

      response = http_post("/message:send", body)
      response.code.to_i.should.equal 200

      data = parse_json(response)
      (data.key?("task") || data.key?("message")).should.equal true
    end
  end
end
