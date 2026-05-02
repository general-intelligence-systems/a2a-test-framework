require "a2a_test_framework/test_helper"

# NOTE: All tests commented out -- gRPC binding not supported by reference server

# require "a2a_test_framework/test_helper"

# # NOTE: All tests commented out -- gRPC binding not supported by reference server

# # describe "A2AService/CreateTaskPushNotificationConfig" do
# #   # --- Successful Creation ---
# #
# #   describe "when a client creates a push notification config with a valid webhook URL" do
# #     it "should respond with a PushNotificationConfig object" do
# #     end
# #
# #     it "should contain an assigned ID in the response" do
# #     end
# #   end
# #
# #   describe "when a push notification config is created for a task" do
# #     it "should establish a webhook endpoint for task update notifications" do
# #     end
# #
# #     it "should send HTTP POST requests to the configured webhook URL when task updates occur" do
# #     end
# #   end
# #
# #   describe "when the task status changes after config creation" do
# #     it "should send an HTTP POST request to the configured webhook URL" do
# #     end
# #
# #     it "should send the payload as a StreamResponse object" do
# #     end
# #   end
# #
# #   # --- Configuration Persistence ---
# #
# #   describe "when a push notification config exists for a non-terminal task" do
# #     it "should remain active while the task is in a non-terminal state" do
# #     end
# #
# #     it "should remain active until explicitly deleted" do
# #     end
# #   end
# #
# #   describe "when a task with push notification config reaches completed state" do
# #     it "should not require the configuration to persist beyond task completion" do
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
# #
# #   describe "when a client sends a request for a task not accessible to the client" do
# #     it "should respond with a TaskNotFoundError" do
# #     end
# #   end
# #
# #   # --- Capability Validation ---
# #
# #   describe "when the AgentCard declares pushNotifications capability as true" do
# #     it "should accept and process the request" do
# #     end
# #   end
# #
# #   describe "when the AgentCard declares pushNotifications capability as false" do
# #     it "should respond with a PushNotificationNotSupportedError" do
# #     end
# #   end
# # end
