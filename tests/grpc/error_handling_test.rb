require "a2a_test_framework/test_helper"

# NOTE: All tests commented out -- gRPC binding not supported by reference server

# require "a2a_test_framework/test_helper"

# # NOTE: All tests commented out -- gRPC binding not supported by reference server

# # describe "Error Handling (gRPC)" do
# #   # --- Authentication Errors ---
# #
# #   describe "when a client sends a request without authentication credentials" do
# #     it "should reject the request with an UNAUTHENTICATED status" do
# #     end
# #
# #     it "should include authentication challenge information in the error details" do
# #     end
# #   end
# #
# #   describe "when a client sends a request with invalid authentication credentials" do
# #     it "should reject the request with an UNAUTHENTICATED status" do
# #     end
# #   end
# #
# #   describe "when a client sends a request with an expired bearer token" do
# #     it "should reject the request with an UNAUTHENTICATED status" do
# #     end
# #   end
# #
# #   # --- Authorization Errors ---
# #
# #   describe "when an authenticated client lacks required permissions for an operation" do
# #     it "should return a PERMISSION_DENIED status" do
# #     end
# #
# #     it "should indicate what permission or scope is missing" do
# #     end
# #   end
# #
# #   describe "when an authenticated client attempts to access another client's task" do
# #     it "should not reveal the existence of that task" do
# #     end
# #
# #     it "should not distinguish between does-not-exist and not-authorized" do
# #     end
# #   end
# #
# #   # --- Validation Errors ---
# #
# #   describe "when a client sends a request with an invalid parameter format" do
# #     it "should return an INVALID_ARGUMENT status before processing" do
# #     end
# #
# #     it "should specify which parameter failed validation" do
# #     end
# #
# #     it "should explain why the parameter failed" do
# #     end
# #
# #     it "should provide guidance on valid parameter values or formats" do
# #     end
# #   end
# #
# #   describe "when a client sends a SendMessageRequest with no message parts" do
# #     it "should return an INVALID_ARGUMENT status" do
# #     end
# #   end
# #
# #   # --- Resource Errors ---
# #
# #   describe "when a client requests a resource that does not exist" do
# #     it "should return a NOT_FOUND status" do
# #     end
# #   end
# #
# #   describe "when a client requests a resource not accessible to the authenticated client" do
# #     it "should return a NOT_FOUND status" do
# #     end
# #   end
# #
# #   describe "when comparing not-found vs unauthorized responses" do
# #     it "should not be distinguishable to prevent information leakage" do
# #     end
# #   end
# #
# #   # --- System Errors ---
# #
# #   describe "when the server experiences a temporary internal failure" do
# #     it "should return an UNAVAILABLE status indicating temporary unavailability" do
# #     end
# #
# #     it "should MAY include retry guidance in error details" do
# #     end
# #   end
# #
# #   # --- Error Payload Structure ---
# #
# #   describe "when any error response is returned" do
# #     it "should contain an error code as a machine-readable gRPC status code" do
# #     end
# #
# #     it "should contain a human-readable error message" do
# #     end
# #   end
# #
# #   describe "when an error response includes details" do
# #     it "should include a @type key in each details object" do
# #     end
# #
# #     it "should use ProtoJSON Any representation for the @type key" do
# #     end
# #   end
# #
# #   # --- A2A-Specific Errors ---
# #
# #   describe "when a task ID does not correspond to an existing task" do
# #     it "should return a TaskNotFoundError" do
# #     end
# #   end
# #
# #   describe "when a task existed but has been purged" do
# #     it "should return a TaskNotFoundError" do
# #     end
# #   end
# #
# #   describe "when a CancelTask request targets a completed task" do
# #     it "should return a TaskNotCancelableError" do
# #     end
# #   end
# #
# #   describe "when a CancelTask request targets a failed task" do
# #     it "should return a TaskNotCancelableError" do
# #     end
# #   end
# #
# #   describe "when a CancelTask request targets an already canceled task" do
# #     it "should return a TaskNotCancelableError" do
# #     end
# #   end
# #
# #   describe "when a client attempts push notification features on a non-supporting server" do
# #     it "should return a PushNotificationNotSupportedError" do
# #     end
# #   end
# #
# #   describe "when a client requests an unsupported operation" do
# #     it "should return an UnsupportedOperationError" do
# #     end
# #   end
# #
# #   describe "when a client sends a message with an unsupported media type" do
# #     it "should return a ContentTypeNotSupportedError" do
# #     end
# #   end
# #
# #   describe "when an agent returns a malformed response" do
# #     it "should be classified as InvalidAgentResponseError" do
# #     end
# #   end
# #
# #   describe "when the extended agent card is not configured despite capability being declared" do
# #     it "should return an ExtendedAgentCardNotConfiguredError" do
# #     end
# #   end
# #
# #   describe "when a client does not declare support for a required extension" do
# #     it "should return an ExtensionSupportRequiredError" do
# #     end
# #   end
# #
# #   describe "when a client sends a request with an unsupported protocol version" do
# #     it "should return a VersionNotSupportedError" do
# #     end
# #   end
# # end
