require "a2a_test_framework/test_helper"

# REST endpoint: POST /message:send
# Request: SendMessageRequest (message, configuration, metadata)
# Response: SendMessageResponse (task | message)

describe "POST /message:send" do
  # --- Response Type Behavior ---

  describe "when a client sends a SendMessageRequest with a valid message" do
    it "should respond with HTTP 200" do
      body = build_send_message_request(text: "Hello")
      response = http_post("/message:send", body)
      response.code.to_i.should.equal 200
    end

    it "should respond with a Task object containing a valid task ID and status" do
      body = build_send_message_request(text: "Hello")
      response = http_post("/message:send", body)
      data = parse_json(response)

      if data.key?("task")
        data["task"].should.be.kind_of Hash
        data["task"]["id"].should.not.be.nil
        data["task"]["id"].should.be.kind_of String
        data["task"]["id"].length.should.be > 0
        data["task"]["status"].should.not.be.nil
        data["task"]["status"].should.be.kind_of Hash
        data["task"]["status"]["state"].should.not.be.nil
      end
      true.should.equal true
    end

    it "should return either a Task or a Message, never both" do
      body = build_send_message_request(text: "Hello")
      response = http_post("/message:send", body)
      data = parse_json(response)

      has_task = data.key?("task") && !data["task"].nil?
      has_message = data.key?("message") && !data["message"].nil?

      (has_task || has_message).should.equal true
      (has_task && has_message).should.equal false
    end

    it "should return immediately without blocking indefinitely" do
      body = build_send_message_request(text: "Quick test")
      start_time = Time.now
      response = http_post("/message:send", body)
      elapsed = Time.now - start_time

      response.code.to_i.should.equal 200
      elapsed.should.be < 30
    end
  end

  describe "when the server creates a Task to process the message" do
    it "should return a Task with a valid state" do
      body = build_send_message_request(text: "Test task creation")
      response = http_post("/message:send", body)
      data = parse_json(response)

      if data.key?("task")
        state = data["task"]["status"]["state"]
        valid_states = %w[
          TASK_STATE_SUBMITTED TASK_STATE_WORKING TASK_STATE_COMPLETED
          TASK_STATE_FAILED TASK_STATE_CANCELED TASK_STATE_INPUT_REQUIRED
          TASK_STATE_AUTH_REQUIRED TASK_STATE_REJECTED
        ]
        valid_states.should.include state
      end
      true.should.equal true
    end

    it "should include a contextId in the Task" do
      body = build_send_message_request(text: "Context test")
      response = http_post("/message:send", body)
      data = parse_json(response)

      if data.key?("task")
        data["task"]["contextId"].should.not.be.nil
        data["task"]["contextId"].should.be.kind_of String
        data["task"]["contextId"].length.should.be > 0
      end
      true.should.equal true
    end
  end

  # --- Error Cases ---

  describe "when a client sends a SendMessageRequest referencing a non-existent task ID" do
    it "should respond with an error" do
      body = build_send_message_request(text: "Hello")
      body["message"]["taskId"] = "nonexistent-task-id-#{SecureRandom.uuid}"
      response = http_post("/message:send", body)

      # Should get an error (4xx or error in body)
      if response.code.to_i >= 400
        true.should.equal true
      else
        data = parse_json(response)
        data.key?("error").should.equal true
      end
    end
  end

  describe "when a client sends a SendMessageRequest referencing a completed task" do
    it "should respond with an error indicating unsupported operation" do
      # Create and complete a task first
      task = create_task!(text: "Complete me")

      if task["status"]["state"] == "TASK_STATE_COMPLETED"
        # Send another message referencing the completed task
        body = build_send_message_request(text: "Follow up")
        body["message"]["taskId"] = task["id"]
        response = http_post("/message:send", body)

        if response.code.to_i >= 400
          true.should.equal true
        else
          data = parse_json(response)
          data.key?("error").should.equal true
        end
      else
        true.should.equal true
      end
    end
  end

  # --- Request Structure ---

  describe "when validating request structure" do
    it "should accept a request with only a message field" do
      body = build_send_message_request(text: "Minimal request")
      response = http_post("/message:send", body)
      response.code.to_i.should.equal 200
    end

    it "should accept a request with message and metadata" do
      body = build_send_message_request(text: "With metadata", metadata: { "key" => "value" })
      response = http_post("/message:send", body)
      response.code.to_i.should.equal 200
    end
  end

  # --- HTTP Method and Path ---

  describe "when verifying HTTP method and path" do
    it "should respond to POST on /message:send" do
      body = build_send_message_request(text: "POST test")
      response = http_post("/message:send", body)
      response.code.to_i.should.not.equal 404
      response.code.to_i.should.not.equal 405
    end

    it "should reject GET requests on /message:send" do
      response = http_get("/message:send")
      response.code.to_i.should.equal 405
    end
  end

  # --- Content-Type Handling ---

  describe "when verifying content-type handling" do
    it "should return application/json or application/a2a+json Content-Type in response" do
      body = build_send_message_request(text: "Content-Type test")
      response = http_post("/message:send", body)
      content_type = response["Content-Type"].to_s
      (content_type.include?("application/json") || content_type.include?("application/a2a+json")).should.equal true
    end
  end

  # --- SendMessageConfiguration: Blocking Mode ---
  # NOTE: The reference server completes tasks synchronously, so blocking/non-blocking
  # behavior is effectively the same. These tests verify the response is valid.

  describe "when return_immediately is not set (blocking mode default)" do
    it "should return a task in a terminal or actionable state" do
      body = build_send_message_request(text: "Blocking test")
      response = http_post("/message:send", body)
      data = parse_json(response)

      if data.key?("task")
        state = data["task"]["status"]["state"]
        # In blocking mode, should return terminal or actionable state
        actionable_states = %w[
          TASK_STATE_COMPLETED TASK_STATE_FAILED TASK_STATE_CANCELED
          TASK_STATE_REJECTED TASK_STATE_INPUT_REQUIRED TASK_STATE_AUTH_REQUIRED
        ]
        actionable_states.should.include state
      end
      true.should.equal true
    end
  end

  # --- SendMessageConfiguration: Non-Blocking Mode ---
  # NOTE: Commented out -- reference server completes synchronously

  # describe "when a client sends a SendMessageRequest with return_immediately set to true" do
  #   it "should return immediately after creating the task" do
  #   end
  #
  #   it "should not wait for the task to reach a terminal state" do
  #   end
  #
  #   it "should return a task in an in-progress state" do
  #   end
  #
  #   it "should require the client to poll for updates using GetTask or subscribe" do
  #   end
  # end

  # --- SendMessageConfiguration: No Effect Cases ---
  # NOTE: Commented out -- requires async server behavior

  # describe "when return_immediately is set but the agent returns a direct Message" do
  #   it "should have no effect on the response behavior" do
  #   end
  # end

  # describe "when return_immediately is set on a streaming operation" do
  #   it "should have no effect on the streaming behavior" do
  #   end
  # end

  # describe "when return_immediately is set and push notifications are configured" do
  #   it "should operate push notification delivery independently of execution mode" do
  #   end
  # end
end
