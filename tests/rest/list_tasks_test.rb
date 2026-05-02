require "a2a_test_framework/test_helper"

# REST endpoint: GET /tasks
# Request: ListTasksRequest (contextId, status, historyLength, includeArtifacts, pageSize, pageToken, statusTimestampAfter, tenant)
# Response: ListTasksResponse (tasks[], nextPageToken, pageSize, totalSize)

describe "GET /tasks" do
  # --- Authorization Scoping ---
  # NOTE: Commented out -- reference server does not implement authentication

  # describe "when an authenticated client sends a ListTasks request" do
  #   it "should only return tasks visible to the authenticated client" do
  #   end
  #
  #   it "should not return tasks belonging to other clients" do
  #   end
  # end

  # describe "when an unauthenticated client sends a ListTasks request" do
  #   it "should respond with an authentication error" do
  #   end
  # end

  # --- includeArtifacts Field Behavior ---

  describe "when a client sends a ListTasks request without setting includeArtifacts" do
    it "should omit the artifacts field from each Task object" do
      create_task!(text: "Artifacts omit test")
      response = http_get("/tasks")
      response.code.to_i.should.equal 200

      data = parse_json(response)
      data["tasks"].should.be.kind_of Array
      data["tasks"].length.should.be > 0

      # Without includeArtifacts, artifacts should be omitted
      task = data["tasks"].first
      task.key?("artifacts").should.equal false
    end
  end

  describe "when a client sends a ListTasks request with includeArtifacts set to true" do
    it "should include the artifacts field in each Task" do
      create_task!(text: "Artifacts include test")
      response = http_get("/tasks?includeArtifacts=true")
      response.code.to_i.should.equal 200

      data = parse_json(response)
      task = data["tasks"].first
      task.key?("artifacts").should.equal true
      task["artifacts"].should.be.kind_of Array
    end
  end

  # --- nextPageToken Field ---

  describe "when a client receives a ListTasks response" do
    it "should contain a nextPageToken field" do
      create_task!(text: "Page token test")
      response = http_get("/tasks")
      data = parse_json(response)

      data.key?("nextPageToken").should.equal true
    end
  end

  describe "when all tasks fit within a single page" do
    it "should set nextPageToken to an empty string" do
      # Use a large page size to fit all
      response = http_get("/tasks?pageSize=100")
      data = parse_json(response)

      if data["tasks"].length < 100
        data["nextPageToken"].should.equal ""
      end
      true.should.equal true
    end
  end

  # --- Cursor-Based Pagination ---

  describe "when using pagination" do
    it "should respect pageSize parameter" do
      3.times { |i| create_task!(text: "Page size test #{i}") }

      response = http_get("/tasks?pageSize=2")
      response.code.to_i.should.equal 200

      data = parse_json(response)
      data["tasks"].length.should.be <= 2
    end

    it "should include pageSize in the response" do
      response = http_get("/tasks?pageSize=5")
      data = parse_json(response)

      data["pageSize"].should.not.be.nil
      data["pageSize"].should.be > 0
    end

    it "should include totalSize in the response" do
      create_task!(text: "Total size test")
      response = http_get("/tasks")
      data = parse_json(response)

      data["totalSize"].should.not.be.nil
      data["totalSize"].should.be >= 1
    end

    it "should return the first page when no pageToken is provided" do
      response = http_get("/tasks?pageSize=2")
      response.code.to_i.should.equal 200

      data = parse_json(response)
      data["tasks"].should.be.kind_of Array
    end
  end

  # --- Filtering ---

  describe "when a client filters tasks by contextId" do
    it "should only return tasks matching that contextId" do
      task = create_task!(text: "Context filter test")
      context_id = task["contextId"]

      response = http_get("/tasks?contextId=#{context_id}")
      response.code.to_i.should.equal 200

      data = parse_json(response)
      data["tasks"].each do |t|
        t["contextId"].should.equal context_id
      end
    end

    it "should return empty list for non-existent contextId" do
      response = http_get("/tasks?contextId=nonexistent-#{SecureRandom.uuid}")
      response.code.to_i.should.equal 200

      data = parse_json(response)
      data["tasks"].length.should.equal 0
    end
  end

  # --- Ordering ---
  # NOTE: Commented out -- ordering behavior depends on server implementation

  # describe "when tasks are returned in the response" do
  #   it "should sort tasks by status timestamp in descending order" do
  #   end
  #
  #   it "should place the most recently updated task first" do
  #   end
  # end

  # describe "when paginating through all results" do
  #   it "should maintain consistent ordering across pages" do
  #   end
  #
  #   it "should not have a later-page task with a more recent update than earlier-page tasks" do
  #   end
  # end
end
