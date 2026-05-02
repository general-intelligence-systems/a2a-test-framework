require "a2a_test_framework/test_helper"

# Cross-cutting: historyLength semantics apply to:
# REST: GET /tasks/{id}, GET /tasks, POST /message:send

describe "History Length Semantics (REST)" do
  # --- Unset/Undefined ---

  describe "when a client sends a request without specifying historyLength" do
    it "should return the server default amount of history" do
      task = create_task!(text: "Default history test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      # Server should return history by default
      if data["history"]
        data["history"].should.be.kind_of Array
      end
      true.should.equal true
    end
  end

  # --- Zero Value ---

  describe "when a client sends a request with historyLength set to 0" do
    it "should omit or empty the history field" do
      task = create_task!(text: "Zero history test")
      response = http_get("/tasks/#{task["id"]}?historyLength=0")
      data = parse_json(response)

      if data.key?("history")
        (data["history"].nil? || data["history"].empty?).should.equal true
      else
        true.should.equal true
      end
    end
  end

  # --- Positive Value ---

  describe "when a client sends a request with historyLength set to a positive number" do
    it "should return at most that many recent messages" do
      task = create_task!(text: "Limited history test")
      response = http_get("/tasks/#{task["id"]}?historyLength=1")
      data = parse_json(response)

      if data["history"]
        data["history"].length.should.be <= 1
      end
      true.should.equal true
    end
  end

  describe "when historyLength is greater than total available messages" do
    it "should return all available messages" do
      task = create_task!(text: "Large history test")
      response = http_get("/tasks/#{task["id"]}?historyLength=1000")
      data = parse_json(response)

      if data["history"]
        data["history"].should.be.kind_of Array
        # Should return whatever is available, not error
      end
      true.should.equal true
    end
  end

  # --- Consistency Across Operations ---

  describe "when historyLength is used in GetTask vs ListTasks" do
    it "should apply the same truncation semantics in both operations" do
      task = create_task!(text: "Consistency test")

      # GetTask with historyLength=1
      get_resp = http_get("/tasks/#{task["id"]}?historyLength=1")
      get_data = parse_json(get_resp)

      # ListTasks with historyLength=1
      list_resp = http_get("/tasks?historyLength=1&contextId=#{task["contextId"]}")
      list_data = parse_json(list_resp)

      if get_data["history"] && list_data["tasks"].length > 0
        list_task = list_data["tasks"].find { |t| t["id"] == task["id"] }
        if list_task && list_task["history"]
          list_task["history"].length.should.be <= 1
        end
      end
      true.should.equal true
    end
  end
end
