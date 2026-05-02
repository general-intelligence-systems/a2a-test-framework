require "a2a_test_framework/test_helper"

# NOTE: All tests commented out -- gRPC binding not supported by reference server

# require "a2a_test_framework/test_helper"

# # NOTE: All tests commented out -- gRPC binding not supported by reference server

# # describe "gRPC Protocol Binding" do
# #   # --- Protocol Requirements ---
# #
# #   describe "when using the gRPC binding" do
# #     it "should use gRPC over HTTP/2 with TLS" do
# #     end
# #
# #     it "should use Protocol Buffers version 3 for serialization" do
# #     end
# #
# #     it "should implement the A2AService gRPC service" do
# #     end
# #   end
# #
# #   # --- Service Parameter Transmission ---
# #
# #   describe "when transmitting A2A service parameters" do
# #     it "should use gRPC metadata (headers)" do
# #     end
# #
# #     it "should transmit A2A-Version as a gRPC metadata key" do
# #     end
# #
# #     it "should comma-separate multiple extension values in a single metadata entry" do
# #     end
# #   end
# #
# #   describe "when the server receives a request" do
# #     it "should extract service parameters from gRPC metadata" do
# #     end
# #
# #     it "should validate required service parameters from metadata" do
# #     end
# #   end
# #
# #   # --- Error Handling ---
# #
# #   describe "when an error occurs" do
# #     it "should use the standard gRPC status structure (google.rpc.Status)" do
# #     end
# #
# #     it "should map error code to the status.code field" do
# #     end
# #
# #     it "should include error message in status.message field" do
# #     end
# #   end
# #
# #   describe "when an A2A-specific error occurs" do
# #     it "should include google.rpc.ErrorInfo in status.details" do
# #     end
# #
# #     it "should use UPPER_SNAKE_CASE without Error suffix in ErrorInfo reason" do
# #     end
# #
# #     it "should set ErrorInfo domain to a2a-protocol.org" do
# #     end
# #   end
# #
# #   # --- Streaming ---
# #
# #   describe "when a streaming operation is invoked" do
# #     it "should use server streaming RPCs for real-time updates" do
# #     end
# #   end
# # end
