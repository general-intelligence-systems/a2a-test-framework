require "a2a_test_framework/test_helper"

# Cross-cutting: Capability validation applies to all optional endpoints

describe "Capability Validation (REST)" do
  # --- Push Notifications Capability ---
  # NOTE: Reference server declares pushNotifications=true, so these
  # test the positive case. Negative case (false) is commented out.

  # describe "when pushNotifications capability is false or not declared" do
  #   it "should return PushNotificationNotSupportedError on CreatePushNotificationConfig" do
  #   end
  # end

  # --- Streaming Capability ---
  # NOTE: Reference server declares streaming=true

  # describe "when streaming capability is false or not declared" do
  #   it "should return UnsupportedOperationError on SendStreamingMessage" do
  #   end
  #
  #   it "should return UnsupportedOperationError on SubscribeToTask" do
  #   end
  # end

  # --- Extended Agent Card Capability ---

  describe "when extendedAgentCard capability is false or not declared" do
    it "should return an error on GetExtendedAgentCard" do
      # Reference server has extendedAgentCard=false
      response = http_get("/extendedAgentCard")

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  # --- Capability Declaration in AgentCard ---

  describe "when examining the AgentCard capabilities" do
    it "should declare streaming capability" do
      response = http_get("/.well-known/agent-card.json")
      data = parse_json(response)

      data["capabilities"].key?("streaming").should.equal true
      data["capabilities"]["streaming"].should.equal true
    end

    it "should declare pushNotifications capability" do
      response = http_get("/.well-known/agent-card.json")
      data = parse_json(response)

      data["capabilities"].key?("pushNotifications").should.equal true
      data["capabilities"]["pushNotifications"].should.equal true
    end

    it "should declare extendedAgentCard capability" do
      response = http_get("/.well-known/agent-card.json")
      data = parse_json(response)

      data["capabilities"].key?("extendedAgentCard").should.equal true
      # Reference server sets this to false
      data["capabilities"]["extendedAgentCard"].should.equal false
    end
  end

  # --- Extensions Capability ---
  # NOTE: Commented out -- reference server doesn't use required extensions

  # describe "when the AgentCard lists a required extension" do
  #   it "should return ExtensionSupportRequiredError if client does not declare support" do
  #   end
  # end
end
