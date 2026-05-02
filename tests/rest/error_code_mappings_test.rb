require "a2a_test_framework/test_helper"

# Cross-cutting: HTTP status code mappings for REST binding

describe "Error Code Mappings (REST - HTTP Status)" do
  describe "when a TaskNotFoundError occurs" do
    it "should return HTTP 404 Not Found" do
      response = http_get("/tasks/nonexistent-#{SecureRandom.uuid}")
      response.code.to_i.should.equal 404
    end
  end

  describe "when a TaskNotCancelableError occurs" do
    it "should return HTTP 400 Bad Request" do
      task = create_task!(text: "Cancel error code test")
      response = http_post("/tasks/#{task["id"]}:cancel", {})
      response.code.to_i.should.equal 400
    end
  end

  describe "when an UnsupportedOperationError occurs" do
    it "should return HTTP 400 Bad Request" do
      response = http_get("/extendedAgentCard")
      # Extended agent card returns unsupported operation
      response.code.to_i.should.equal 400
    end
  end

  # NOTE: Commented out -- difficult to trigger these specific errors

  # describe "when a ContentTypeNotSupportedError occurs" do
  #   it "should return HTTP 400 Bad Request" do
  #   end
  # end

  # describe "when an InvalidAgentResponseError occurs" do
  #   it "should return HTTP 500 Internal Server Error" do
  #   end
  # end

  # describe "when a PushNotificationNotSupportedError occurs" do
  #   it "should return HTTP 400 Bad Request" do
  #   end
  # end
end
