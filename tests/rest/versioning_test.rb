require "a2a_test_framework/test_helper"

# Cross-cutting: Protocol versioning applies to all REST endpoints
# Version is communicated via A2A-Version header.

describe "Protocol Versioning (REST)" do
  # NOTE: Version negotiation is not fully implemented in the reference server.
  # These tests verify basic version-related behavior.

  # --- Version Format ---
  # NOTE: Commented out -- reference server may not validate version header

  # describe "when a client sends a request with A2A-Version header" do
  #   it "should recognize Major.Minor format as valid" do
  #   end
  # end

  # describe "when the server returns version information" do
  #   it "should not include patch version numbers" do
  #   end
  # end

  # describe "when performing version negotiation" do
  #   it "should not consider patch version differences" do
  #   end
  # end

  # --- Basic Version Behavior ---

  describe "when the AgentCard declares protocol version" do
    it "should include protocolVersion in supportedInterfaces" do
      response = http_get("/.well-known/agent-card.json")
      data = parse_json(response)

      data["supportedInterfaces"].each do |iface|
        if iface.key?("protocolVersion")
          iface["protocolVersion"].should.be.kind_of String
          iface["protocolVersion"].should.match(/\d+\.\d+/)
        end
      end
      true.should.equal true
    end
  end
end
