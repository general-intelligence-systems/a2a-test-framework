require "a2a_test_framework/test_helper"

# NOTE: All tests commented out -- gRPC binding not supported by reference server

# require "a2a_test_framework/test_helper"

# # NOTE: All tests commented out -- gRPC binding not supported by reference server

# # describe "A2AService/SendMessage" do
# #   # --- Response Type Behavior ---
# #
# #   describe "when a client sends a SendMessageRequest with a valid message" do
# #     it "should respond with a Task object containing a valid task ID and status" do
# #     end
# #
# #     it "should return either a Task or a Message, never both" do
# #     end
# #
# #     it "should return immediately without blocking on task completion" do
# #     end
# #   end
# #
# #   describe "when a client sends a SendMessageRequest with a simple message" do
# #     it "should respond with a Message object containing a role" do
# #     end
# #
# #     it "should respond with a Message object containing one or more Parts" do
# #     end
# #   end
# #
# #   describe "when the server creates a Task to process the message asynchronously" do
# #     it "should return a Task that MAY be in a non-terminal state" do
# #     end
# #
# #     it "should allow task processing to continue after response is returned" do
# #     end
# #   end
# #
# #   # --- Response Structure Validation ---
# #
# #   describe "when validating the response structure" do
# #     it "should contain exactly one of Task or Message" do
# #     end
# #
# #     it "should never contain both a Task and a Message simultaneously" do
# #     end
# #   end
# #
# #   # --- Error Cases ---
# #
# #   describe "when a client sends a Part with an unsupported media type" do
# #     it "should respond with a ContentTypeNotSupportedError" do
# #     end
# #   end
# #
# #   describe "when a client sends a SendMessageRequest referencing a completed task" do
# #     it "should respond with an UnsupportedOperationError" do
# #     end
# #   end
# #
# #   describe "when a client sends a SendMessageRequest referencing a canceled task" do
# #     it "should respond with an UnsupportedOperationError" do
# #     end
# #   end
# #
# #   describe "when a client sends a SendMessageRequest referencing a rejected task" do
# #     it "should respond with an UnsupportedOperationError" do
# #     end
# #   end
# #
# #   describe "when a client sends a SendMessageRequest referencing a non-existent task ID" do
# #     it "should respond with a TaskNotFoundError" do
# #     end
# #   end
# #
# #   describe "when a client sends a SendMessageRequest referencing a task not accessible to the client" do
# #     it "should respond with a TaskNotFoundError" do
# #     end
# #   end
# #
# #   # --- SendMessageConfiguration: Blocking Mode (Default) ---
# #
# #   describe "when a client sends a SendMessageRequest with return_immediately unset (blocking mode)" do
# #     it "should wait until the task reaches completed state before returning" do
# #     end
# #
# #     it "should wait until the task reaches failed state before returning" do
# #     end
# #
# #     it "should wait until the task reaches canceled state before returning" do
# #     end
# #
# #     it "should wait until the task reaches rejected state before returning" do
# #     end
# #
# #     it "should wait until the task reaches input_required state before returning" do
# #     end
# #
# #     it "should wait until the task reaches auth_required state before returning" do
# #     end
# #
# #     it "should include the latest task state with all artifacts and status information" do
# #     end
# #
# #     it "should behave in blocking mode by default when return_immediately is not specified" do
# #     end
# #   end
# #
# #   # --- SendMessageConfiguration: Non-Blocking Mode ---
# #
# #   describe "when a client sends a SendMessageRequest with return_immediately set to true" do
# #     it "should return immediately after creating the task" do
# #     end
# #
# #     it "should not wait for the task to reach a terminal state" do
# #     end
# #
# #     it "should return a task in an in-progress state" do
# #     end
# #
# #     it "should require the client to poll for updates using GetTask or subscribe" do
# #     end
# #   end
# #
# #   # --- SendMessageConfiguration: No Effect Cases ---
# #
# #   describe "when return_immediately is set but the agent returns a direct Message" do
# #     it "should have no effect on the response behavior" do
# #     end
# #   end
# #
# #   describe "when return_immediately is set on a streaming operation" do
# #     it "should have no effect on the streaming behavior" do
# #     end
# #   end
# #
# #   describe "when return_immediately is set and push notifications are configured" do
# #     it "should operate push notification delivery independently of execution mode" do
# #     end
# #   end
# # end
