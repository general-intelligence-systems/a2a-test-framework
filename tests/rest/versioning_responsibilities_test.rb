require "a2a_test_framework/test_helper"

# NOTE: All tests commented out -- Reference server does not implement version negotiation

# require "a2a_test_framework/test_helper"

# # NOTE: All tests commented out -- Reference server does not implement version negotiation

# # describe "Versioning - Server Responsibilities (REST)" do
# #   describe "when a client sends a request with A2A-Version for a supported version" do
# #     it "should process the request using the semantics of the requested version" do
# #     end
# #   end
# #
# #   describe "when a client requests an older supported version" do
# #     it "should process the request using the older version semantics" do
# #     end
# #   end
# #
# #   describe "when a client requests an unsupported version" do
# #     it "should return a VersionNotSupportedError" do
# #     end
# #   end
# #
# #   describe "when a client sends an empty A2A-Version value" do
# #     it "should interpret the empty value as version 0.3" do
# #     end
# #   end
# #
# #   describe "when a client sends a request without an A2A-Version header" do
# #     it "should interpret the missing header as version 0.3" do
# #     end
# #   end
# # end
# #
# # describe "Versioning - Client Responsibilities (REST)" do
# #   describe "when a client sends any request to an A2A server" do
# #     it "should include the A2A-Version header" do
# #     end
# #   end
# #
# #   describe "when A2A-Version is provided as a query parameter" do
# #     it "should accept it as equivalent to the A2A-Version header" do
# #     end
# #   end
# # end
