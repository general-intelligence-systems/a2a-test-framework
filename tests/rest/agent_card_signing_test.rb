require "a2a_test_framework/test_helper"

# NOTE: All tests commented out -- Reference server does not implement agent card signing

# require "a2a_test_framework/test_helper"

# # NOTE: All tests commented out -- Reference server does not implement agent card signing

# # describe "Agent Card Signing (REST)" do
# #   # --- Canonicalization Requirements ---
# #
# #   describe "when an Agent Card is signed" do
# #     it "should canonicalize content using JCS (RFC 8785) before signing" do
# #     end
# #
# #     it "should omit optional fields not explicitly set before canonicalization" do
# #     end
# #
# #     it "should include optional fields explicitly set to defaults" do
# #     end
# #
# #     it "should always include required fields in canonical form" do
# #     end
# #
# #     it "should order properties lexicographically per RFC 8785" do
# #     end
# #
# #     it "should remove insignificant whitespace per RFC 8785" do
# #     end
# #
# #     it "should exclude the signatures field from content being signed" do
# #     end
# #   end
# #
# #   # --- Signature Format ---
# #
# #   describe "when validating a signed Agent Card" do
# #     it "should include alg parameter in JWS protected header" do
# #     end
# #
# #     it "should include kid parameter in JWS protected header" do
# #     end
# #
# #     it "should have typ set to JOSE in the protected header" do
# #     end
# #
# #     it "should have a base64url-encoded JSON protected field" do
# #     end
# #
# #     it "should have a base64url-encoded signature value" do
# #     end
# #   end
# #
# #   # --- Signature Verification ---
# #
# #   describe "when a client verifies an Agent Card signature" do
# #     it "should follow verification steps in order" do
# #     end
# #
# #     it "should verify at least one signature before trusting the Agent Card" do
# #     end
# #
# #     it "should retrieve public keys over HTTPS" do
# #     end
# #
# #     it "should not use expired or revoked keys for verification" do
# #     end
# #   end
# #
# #   describe "when an Agent Card has multiple signatures" do
# #     it "should accept multiple signatures for key rotation support" do
# #     end
# #   end
# # end
