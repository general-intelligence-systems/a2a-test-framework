require "a2a_test_framework/test_helper"

# NOTE: All tests commented out -- gRPC binding not supported by reference server

# require "a2a_test_framework/test_helper"

# # NOTE: All tests commented out -- gRPC binding not supported by reference server

# # describe "A2AService/GetTask" do
# #   # --- Successful Retrieval ---
# #
# #   describe "when a client retrieves an existing task" do
# #     it "should respond with a Task object" do
# #     end
# #
# #     it "should include the current status in the Task object" do
# #     end
# #
# #     it "should include any generated artifacts in the Task object" do
# #     end
# #   end
# #
# #   describe "when a task is in working state" do
# #     it "should return a status field reflecting the current state" do
# #     end
# #   end
# #
# #   describe "when a task has generated artifacts" do
# #     it "should include the artifacts field in the response" do
# #     end
# #   end
# #
# #   describe "when polling for task completion after SendMessage" do
# #     it "should return the task with completed status once processing finishes" do
# #     end
# #   end
# #
# #   describe "when retrieving a task after push notification received" do
# #     it "should respond with a Task object reflecting the final state" do
# #     end
# #   end
# #
# #   describe "when retrieving a task after stream has ended" do
# #     it "should respond with a Task object reflecting the final state" do
# #     end
# #   end
# #
# #   # --- History Length Parameter ---
# #
# #   describe "when a client sends a GetTask request with historyLength set to a positive number" do
# #     it "should include up to that many recent messages in the history field" do
# #     end
# #   end
# #
# #   describe "when a client sends a GetTask request with historyLength set to 0" do
# #     it "should omit the history field from the response" do
# #     end
# #   end
# #
# #   describe "when a client sends a GetTask request without specifying historyLength" do
# #     it "should return the server default amount of history" do
# #     end
# #   end
# #
# #   # --- Error Cases ---
# #
# #   describe "when a client sends a GetTask request with a non-existent task ID" do
# #     it "should respond with a TaskNotFoundError" do
# #     end
# #   end
# #
# #   describe "when a client sends a GetTask request for a task not accessible to the client" do
# #     it "should respond with a TaskNotFoundError" do
# #     end
# #   end
# # end
