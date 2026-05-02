require "a2a_test_framework/test_helper"

# NOTE: All tests commented out -- gRPC binding not supported by reference server

# require "a2a_test_framework/test_helper"

# # NOTE: All tests commented out -- gRPC binding not supported by reference server

# # describe "A2AService/SubscribeToTask" do
# #   # --- Stream Initialization ---
# #
# #   describe "when a client subscribes to a working task" do
# #     it "should send a Task object as the first event in the stream" do
# #     end
# #
# #     it "should represent the current state of the task at time of subscription" do
# #     end
# #
# #     it "should not require a separate GetTask call to avoid missing updates" do
# #     end
# #   end
# #
# #   # --- Stream Content ---
# #
# #   describe "when the subscribed task status changes" do
# #     it "should deliver a TaskStatusUpdateEvent object" do
# #     end
# #   end
# #
# #   describe "when the subscribed task generates a new artifact" do
# #     it "should deliver a TaskArtifactUpdateEvent object" do
# #     end
# #   end
# #
# #   # --- Stream Termination ---
# #
# #   describe "when the subscribed task reaches a terminal state" do
# #     it "should terminate the stream when task reaches completed state" do
# #     end
# #
# #     it "should terminate the stream when task reaches failed state" do
# #     end
# #
# #     it "should terminate the stream when task reaches canceled state" do
# #     end
# #
# #     it "should terminate the stream when task reaches rejected state" do
# #     end
# #   end
# #
# #   describe "when the subscribed task is in a non-terminal state" do
# #     it "should keep the stream open while task is in working state" do
# #     end
# #   end
# #
# #   # --- Error Cases ---
# #
# #   describe "when the server does not support streaming" do
# #     it "should respond with an UnsupportedOperationError" do
# #     end
# #   end
# #
# #   describe "when a client subscribes to a non-existent task ID" do
# #     it "should respond with a TaskNotFoundError" do
# #     end
# #   end
# #
# #   describe "when a client subscribes to a task not accessible to the client" do
# #     it "should respond with a TaskNotFoundError" do
# #     end
# #   end
# #
# #   describe "when a client subscribes to a task in completed state" do
# #     it "should respond with an UnsupportedOperationError" do
# #     end
# #   end
# #
# #   describe "when a client subscribes to a task in failed state" do
# #     it "should respond with an UnsupportedOperationError" do
# #     end
# #   end
# #
# #   describe "when a client subscribes to a task in canceled state" do
# #     it "should respond with an UnsupportedOperationError" do
# #     end
# #   end
# #
# #   describe "when a client subscribes to a task in rejected state" do
# #     it "should respond with an UnsupportedOperationError" do
# #     end
# #   end
# # end
