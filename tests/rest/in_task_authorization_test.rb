require "a2a_test_framework/test_helper"

# NOTE: All tests commented out -- Reference server does not implement in-task authorization

# require "a2a_test_framework/test_helper"

# # NOTE: All tests commented out -- Reference server does not implement in-task authorization

# # describe "In-Task Authorization - Client and Security (REST)" do
# #   # --- Client Responsibilities ---
# #
# #   describe "when a client agent receives TASK_STATE_AUTH_REQUIRED from downstream" do
# #     it "should transition its own Task to TASK_STATE_AUTH_REQUIRED" do
# #     end
# #
# #     it "should follow all In-Task Authorization Agent Responsibilities" do
# #     end
# #   end
# #
# #   describe "when a task transitions to TASK_STATE_AUTH_REQUIRED without an active stream" do
# #     it "should subscribe to task events using SubscribeToTask" do
# #     end
# #
# #     it "should OR register a webhook using CreatePushNotificationConfig" do
# #     end
# #
# #     it "should OR begin polling using GetTask" do
# #     end
# #   end
# #
# #   # --- Security Considerations ---
# #
# #   describe "when the agent requires credentials for in-task authorization" do
# #     it "should receive credentials via a secure channel such as HTTPS" do
# #     end
# #   end
# #
# #   describe "when credentials are passed through a chain of agents" do
# #     it "should bind credentials to the agent which originated the request" do
# #     end
# #
# #     it "should encrypt sensitive credentials so only the originating agent can read them" do
# #     end
# #   end
# # end
