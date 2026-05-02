require "a2a_test_framework/test_helper"

# Agent discovery: well-known URI and AgentCard structure

describe "Agent Discovery (REST)" do
  # --- Purpose ---

  describe "when a server is running" do
    it "should make an Agent Card available at the well-known URI" do
      response = http_get("/.well-known/agent-card.json")
      response.code.to_i.should.equal 200
    end

    it "should describe identity, capabilities, skills, and interaction requirements" do
      response = http_get("/.well-known/agent-card.json")
      data = parse_json(response)

      # Identity
      data["name"].should.not.be.nil
      data["name"].should.be.kind_of String
      data["version"].should.not.be.nil

      # Capabilities
      data["capabilities"].should.not.be.nil
      data["capabilities"].should.be.kind_of Hash

      # Skills
      data["skills"].should.not.be.nil
      data["skills"].should.be.kind_of Array
      data["skills"].length.should.be > 0
    end
  end

  # --- Discovery Mechanisms ---

  describe "when a client requests the well-known Agent Card URI" do
    it "should return the Agent Card as JSON from /.well-known/agent-card.json" do
      response = http_get("/.well-known/agent-card.json")
      response.code.to_i.should.equal 200

      content_type = response["Content-Type"].to_s
      content_type.should.include "json"

      data = parse_json(response)
      data.should.be.kind_of Hash
      data["name"].should.not.be.nil
    end
  end

  # --- Supported Interfaces Declaration ---

  describe "when the AgentCard declares supportedInterfaces" do
    it "should declare supported protocol combinations" do
      response = http_get("/.well-known/agent-card.json")
      data = parse_json(response)

      data["supportedInterfaces"].should.not.be.nil
      data["supportedInterfaces"].should.be.kind_of Array
      data["supportedInterfaces"].length.should.be > 0
    end

    it "should include protocolBinding and url for each interface" do
      response = http_get("/.well-known/agent-card.json")
      data = parse_json(response)

      data["supportedInterfaces"].each do |iface|
        iface["url"].should.not.be.nil
        iface["protocolBinding"].should.not.be.nil
      end
    end
  end

  # --- AgentCard Structure ---

  describe "when validating AgentCard structure" do
    it "should include a name field" do
      response = http_get("/.well-known/agent-card.json")
      data = parse_json(response)
      data["name"].should.be.kind_of String
      data["name"].length.should.be > 0
    end

    it "should include a version field" do
      response = http_get("/.well-known/agent-card.json")
      data = parse_json(response)
      data["version"].should.be.kind_of String
      data["version"].length.should.be > 0
    end

    it "should include capabilities with boolean fields" do
      response = http_get("/.well-known/agent-card.json")
      data = parse_json(response)

      caps = data["capabilities"]
      caps.key?("streaming").should.equal true
      caps.key?("pushNotifications").should.equal true
    end

    it "should include skills with required fields" do
      response = http_get("/.well-known/agent-card.json")
      data = parse_json(response)

      skill = data["skills"].first
      skill["id"].should.not.be.nil
      skill["name"].should.not.be.nil
      skill["description"].should.not.be.nil
    end
  end

  # --- Client Protocol Selection ---
  # NOTE: Commented out -- behavioral requirement, not testable against single server

  # describe "when a client parses supportedInterfaces" do
  #   it "should select the first supported transport from the list" do
  #   end
  # end
end
