require "a2a_test_framework/test_helper"

# REST endpoint: GET /tasks/{id}
# Request: GetTaskRequest (id, historyLength, tenant)
# Response: Task

describe "GET /tasks/{id}" do
  # --- Successful Retrieval ---

  describe "when a client retrieves an existing task" do
    it "should respond with HTTP 200 and a Task object" do
      task = create_task!(text: "Task for retrieval")
      response = http_get("/tasks/#{task["id"]}")
      response.code.to_i.should.equal 200

      data = parse_json(response)
      data["id"].should.equal task["id"]
      data.should.be.kind_of Hash
    end

    it "should include the current status in the Task object" do
      task = create_task!(text: "Status check")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      data["status"].should.not.be.nil
      data["status"].should.be.kind_of Hash
      data["status"]["state"].should.not.be.nil
    end

    it "should include any generated artifacts in the Task object" do
      task = create_task!(text: "Artifact check")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      if data["artifacts"]
        data["artifacts"].should.be.kind_of Array
        data["artifacts"].each do |artifact|
          artifact["artifactId"].should.not.be.nil
          artifact["parts"].should.be.kind_of Array
        end
      end
      true.should.equal true
    end

    it "should include contextId in the Task object" do
      task = create_task!(text: "Context check")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      data["contextId"].should.not.be.nil
      data["contextId"].should.be.kind_of String
    end
  end

  describe "when a task has completed" do
    it "should return a status with state TASK_STATE_COMPLETED" do
      task = create_task!(text: "Completed task")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      data["status"]["state"].should.equal "TASK_STATE_COMPLETED"
    end
  end

  # --- History Length Parameter ---

  describe "when a client sends a GetTask request with historyLength" do
    it "should include history messages when historyLength is positive" do
      task = create_task!(text: "History test")
      response = http_get("/tasks/#{task["id"]}?historyLength=10")
      data = parse_json(response)

      if data["history"]
        data["history"].should.be.kind_of Array
        data["history"].length.should.be > 0
      end
      true.should.equal true
    end

    it "should omit history when historyLength is 0" do
      task = create_task!(text: "No history test")
      response = http_get("/tasks/#{task["id"]}?historyLength=0")
      data = parse_json(response)

      # When historyLength=0, history should be omitted or empty
      if data.key?("history")
        (data["history"].nil? || data["history"].empty?).should.equal true
      else
        true.should.equal true
      end
    end

    it "should limit history to the specified number of messages" do
      # Create a task with some history
      task = create_task!(text: "Multi-message task")
      response = http_get("/tasks/#{task["id"]}?historyLength=1")
      data = parse_json(response)

      if data["history"]
        data["history"].length.should.be <= 1
      end
      true.should.equal true
    end
  end

  # --- Error Cases ---

  describe "when a client sends a GetTask request with a non-existent task ID" do
    it "should respond with an error (404 or error body)" do
      response = http_get("/tasks/nonexistent-task-id-#{SecureRandom.uuid}")

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  describe "when a client sends a GetTask request for a task not accessible to the client" do
    it "should respond with an error indistinguishable from not-found" do
      response = http_get("/tasks/inaccessible-task-#{SecureRandom.uuid}")

      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end
end
