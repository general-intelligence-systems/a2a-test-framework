require "a2a_test_framework/test_helper"

# Cross-cutting: Messages and artifacts semantics

describe "Messages and Artifacts (REST)" do
  # --- Message/Artifact Separation ---

  describe "when a task produces output results" do
    it "should return results using Artifacts associated with the Task" do
      task = create_task!(text: "Artifact output test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      # The echo agent produces artifacts
      data["artifacts"].should.not.be.nil
      data["artifacts"].should.be.kind_of Array
      data["artifacts"].length.should.be > 0

      artifact = data["artifacts"].first
      artifact["parts"].should.be.kind_of Array
      artifact["parts"].length.should.be > 0
    end
  end

  describe "when examining artifact structure" do
    it "should include artifactId for each artifact" do
      task = create_task!(text: "ArtifactId test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      if data["artifacts"] && data["artifacts"].length > 0
        data["artifacts"].each do |artifact|
          artifact["artifactId"].should.not.be.nil
          artifact["artifactId"].should.be.kind_of String
        end
      end
      true.should.equal true
    end

    it "should include parts array in each artifact" do
      task = create_task!(text: "Artifact parts test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      if data["artifacts"] && data["artifacts"].length > 0
        data["artifacts"].each do |artifact|
          artifact["parts"].should.be.kind_of Array
          artifact["parts"].each do |part|
            # Each part should have some content
            has_content = part.key?("text") || part.key?("data") || part.key?("url") || part.key?("raw")
            has_content.should.equal true
          end
        end
      end
      true.should.equal true
    end
  end

  # --- Message History ---

  describe "when examining task history" do
    it "should include both user and agent messages" do
      task = create_task!(text: "History messages test")
      response = http_get("/tasks/#{task["id"]}?historyLength=10")
      data = parse_json(response)

      if data["history"] && data["history"].length > 0
        roles = data["history"].map { |m| m["role"] }
        roles.should.include "ROLE_USER"
        roles.should.include "ROLE_AGENT"
      end
      true.should.equal true
    end

    it "should include messageId in each history message" do
      task = create_task!(text: "Message ID history test")
      response = http_get("/tasks/#{task["id"]}?historyLength=10")
      data = parse_json(response)

      if data["history"] && data["history"].length > 0
        data["history"].each do |msg|
          msg["messageId"].should.not.be.nil
        end
      end
      true.should.equal true
    end
  end

  # --- Message Reliability ---
  # NOTE: Commented out -- cannot test delivery guarantees in conformance suite

  # describe "when a client disconnects and reconnects to a stream" do
  #   it "should not guarantee delivery of all status update messages during disconnection" do
  #   end
  # end

  # describe "when determining message persistence" do
  #   it "should let the agent determine which Messages are persisted in the Task History" do
  #   end
  # end
end
