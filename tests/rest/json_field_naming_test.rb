require "a2a_test_framework/test_helper"

# Cross-cutting: JSON field naming convention applies to all REST endpoints

describe "JSON Field Naming Convention (REST)" do
  # --- camelCase Field Names ---

  describe "when the server returns a JSON response" do
    it "should use camelCase format for all field names" do
      task = create_task!(text: "Field naming test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      # Check for camelCase keys (no underscores)
      data.keys.each do |key|
        key.should.not.match(/_[a-z]/)
      end
    end

    it "should serialize contextId in camelCase" do
      task = create_task!(text: "contextId test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      data.key?("contextId").should.equal true
      data.key?("context_id").should.equal false
    end

    it "should serialize artifactId in camelCase" do
      task = create_task!(text: "artifactId test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      if data["artifacts"] && data["artifacts"].length > 0
        artifact = data["artifacts"].first
        artifact.key?("artifactId").should.equal true
        artifact.key?("artifact_id").should.equal false
      end
      true.should.equal true
    end
  end

  # --- Enum Values ---

  describe "when the server returns a response with enum values" do
    it "should represent task state as SCREAMING_SNAKE_CASE string" do
      task = create_task!(text: "Enum test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      state = data["status"]["state"]
      state.should.match(/\ATASK_STATE_[A-Z_]+\z/)
    end

    it "should represent message role as SCREAMING_SNAKE_CASE string" do
      task = create_task!(text: "Role enum test")
      response = http_get("/tasks/#{task["id"]}?historyLength=10")
      data = parse_json(response)

      if data["history"] && data["history"].length > 0
        role = data["history"].first["role"]
        role.should.match(/\AROLE_(USER|AGENT)\z/)
      end
      true.should.equal true
    end
  end

  # --- Agent Card field naming ---

  describe "when validating agent card field naming" do
    it "should use camelCase for all agent card fields" do
      response = http_get("/.well-known/agent-card.json")
      data = parse_json(response)

      # Check top-level keys
      camel_keys = %w[name version description capabilities skills supportedInterfaces defaultInputModes defaultOutputModes]
      camel_keys.each do |key|
        if data.key?(key)
          true.should.equal true
        end
      end

      # No snake_case keys at top level
      data.keys.each do |key|
        key.should.not.match(/_[a-z]/)
      end
    end
  end
end
