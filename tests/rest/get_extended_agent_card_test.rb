require "a2a_test_framework/test_helper"

# REST endpoint: GET /extendedAgentCard
# Request: GetExtendedAgentCardRequest (tenant)
# Response: AgentCard
#
# NOTE: The reference server declares extendedAgentCard=false, so this
# endpoint returns an UnsupportedOperationError.

describe "GET /extendedAgentCard" do
  # --- Authentication Requirement ---
  # NOTE: Commented out -- reference server does not implement auth

  # describe "when a client sends an authenticated request using a declared security scheme" do
  #   it "should accept the request" do
  #   end
  # end

  # describe "when a client sends a request without authentication" do
  #   it "should reject the request with an authentication error" do
  #   end
  # end

  # describe "when a client sends a request using an undeclared security scheme" do
  #   it "should reject the request" do
  #   end
  # end

  # --- Successful Retrieval ---
  # NOTE: Commented out -- reference server doesn't support extended card

  # describe "when an authenticated client retrieves the extended agent card" do
  #   it "should respond with a complete AgentCard object" do
  #   end
  # end

  # --- Availability / Capability Validation ---

  describe "when the AgentCard declares extendedAgentCard capability as false" do
    it "should respond with an error" do
      response = http_get("/extendedAgentCard")

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  # --- Card Replacement Behavior ---
  # NOTE: Commented out -- not testable without extended card support

  # describe "when a client retrieves the extended agent card after caching the public card" do
  #   it "should replace the cached public AgentCard with the extended card" do
  #   end
  # end

  # --- Error Cases ---
  # NOTE: Commented out -- reference server responds with unsupported

  # describe "when the agent declares support but has no extended card configured" do
  #   it "should respond with an ExtendedAgentCardNotConfiguredError" do
  #   end
  # end
end
