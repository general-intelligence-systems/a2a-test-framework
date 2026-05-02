require "a2a_test_framework/test_helper"

# NOTE: All tests commented out -- gRPC binding not supported by reference server

# require "a2a_test_framework/test_helper"

# # NOTE: All tests commented out -- gRPC binding not supported by reference server

# # describe "A2AService/CancelTask" do
# #   # --- Successful Cancellation ---
# #
# #   describe "when a client sends a CancelTask request for a working task" do
# #     it "should respond with an updated Task object" do
# #     end
# #
# #     it "should reflect the cancellation in the Task status" do
# #     end
# #   end
# #
# #   describe "when a client sends a CancelTask request for a task in input_required state" do
# #     it "should respond with an updated Task object" do
# #     end
# #
# #     it "should reflect the cancellation in the Task status" do
# #     end
# #   end
# #
# #   describe "when a client sends a CancelTask request for a cancelable task" do
# #     it "should return an updated Task object with cancellation status" do
# #     end
# #   end
# #
# #   # --- Error Cases ---
# #
# #   describe "when a client sends a CancelTask request for a completed task" do
# #     it "should respond with a TaskNotCancelableError" do
# #     end
# #   end
# #
# #   describe "when a client sends a CancelTask request for a failed task" do
# #     it "should respond with a TaskNotCancelableError" do
# #     end
# #   end
# #
# #   describe "when a client sends a CancelTask request for an already canceled task" do
# #     it "should respond with a TaskNotCancelableError" do
# #     end
# #   end
# #
# #   describe "when a client sends a CancelTask request with a non-existent task ID" do
# #     it "should respond with a TaskNotFoundError" do
# #     end
# #   end
# #
# #   describe "when a client sends a CancelTask request for a task not accessible to the client" do
# #     it "should respond with a TaskNotFoundError" do
# #     end
# #   end
# #
# #   # --- Idempotency ---
# #
# #   describe "when a client sends multiple CancelTask requests for the same task" do
# #     it "should handle repeated cancellation requests idempotently" do
# #     end
# #
# #     it "should respond with TaskNotCancelableError or TaskNotFoundError on subsequent attempts" do
# #     end
# #   end
# # end
