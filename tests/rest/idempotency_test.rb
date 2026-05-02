require "a2a_test_framework/test_helper"

# Cross-cutting: Idempotency guarantees
# REST: GET /tasks/{id}, GET /tasks, POST /message:send, POST /tasks/{id}:cancel

describe "Operation Idempotency (REST)" do
  # --- Get Operations are Naturally Idempotent ---

  describe "when a client sends repeated GetTask requests for the same task" do
    it "should return the same Task state on both calls" do
      task = create_task!(text: "Idempotent get test")

      response1 = http_get("/tasks/#{task["id"]}")
      response2 = http_get("/tasks/#{task["id"]}")

      data1 = parse_json(response1)
      data2 = parse_json(response2)

      data1["id"].should.equal data2["id"]
      data1["status"]["state"].should.equal data2["status"]["state"]
    end
  end

  describe "when a client sends repeated ListTasks requests" do
    it "should return consistent results" do
      create_task!(text: "Idempotent list test")

      response1 = http_get("/tasks")
      response2 = http_get("/tasks")

      data1 = parse_json(response1)
      data2 = parse_json(response2)

      data1["totalSize"].should.equal data2["totalSize"]
    end
  end

  # --- Cancel Task Idempotency ---

  describe "when a client sends multiple CancelTask requests for the same task" do
    it "should return the same error response each time" do
      task = create_task!(text: "Idempotent cancel test")

      response1 = http_post("/tasks/#{task["id"]}:cancel", {})
      response2 = http_post("/tasks/#{task["id"]}:cancel", {})

      response1.code.to_i.should.equal response2.code.to_i
    end
  end

  # --- Send Message Idempotency ---
  # NOTE: Commented out -- messageId-based deduplication is optional (MAY)

  # describe "when a client sends a SendMessageRequest with the same messageId twice" do
  #   it "should MAY detect the duplicate using messageId" do
  #   end
  #
  #   it "should MAY return the same result without reprocessing" do
  #   end
  # end

  # --- GetExtendedAgentCard ---
  # NOTE: Commented out -- returns error (not supported)

  # describe "when a client sends repeated GetExtendedAgentCard requests" do
  #   it "should return the same AgentCard on both calls" do
  #   end
  # end
end
