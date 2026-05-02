require "a2a_test_framework/test_helper"

# NOTE: All tests commented out -- gRPC binding not supported by reference server

# require "a2a_test_framework/test_helper"

# # NOTE: All tests commented out -- gRPC binding not supported by reference server

# # describe "A2AService/DeleteTaskPushNotificationConfig" do
# #   # --- Successful Deletion ---
# #
# #   describe "when a client deletes an existing push notification config" do
# #     it "should respond with a confirmation of deletion" do
# #     end
# #
# #     it "should permanently remove the configuration" do
# #     end
# #
# #     it "should cause subsequent GetTaskPushNotificationConfig requests to fail" do
# #     end
# #   end
# #
# #   describe "when a task changes status after config deletion" do
# #     it "should not send notifications to the previously configured webhook URL" do
# #     end
# #   end
# #
# #   # --- Idempotency ---
# #
# #   describe "when a client sends multiple delete requests for the same config" do
# #     it "should have the same effect as a single delete" do
# #     end
# #
# #     it "should not return an error on the second request" do
# #     end
# #   end
# #
# #   describe "when a client deletes an already-deleted config" do
# #     it "should not return an error" do
# #     end
# #   end
# #
# #   # --- Error Cases ---
# #
# #   describe "when the server does not support push notifications" do
# #     it "should respond with a PushNotificationNotSupportedError" do
# #     end
# #   end
# #
# #   describe "when a client sends a request with a non-existent task ID" do
# #     it "should respond with a TaskNotFoundError" do
# #     end
# #   end
# # end
