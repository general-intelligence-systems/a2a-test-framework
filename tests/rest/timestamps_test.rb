require "a2a_test_framework/test_helper"
require "time"

# Cross-cutting: Timestamp conventions apply to all REST endpoints returning timestamps

describe "Timestamp Conventions (REST)" do
  # --- Format Requirements ---

  describe "when the server returns a response containing timestamp fields" do
    it "should represent timestamps as ISO 8601 formatted strings" do
      task = create_task!(text: "Timestamp format test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      timestamp = data["status"]["timestamp"]
      timestamp.should.not.be.nil
      # ISO 8601 basic pattern: YYYY-MM-DD followed by T
      timestamp.should.match(/\d{4}-\d{2}-\d{2}T/)
    end

    it "should use UTC timezone denoted by Z suffix" do
      task = create_task!(text: "UTC test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      timestamp = data["status"]["timestamp"]
      timestamp.should.match(/Z\z/)
    end

    it "should be parseable as a valid datetime" do
      task = create_task!(text: "Parseable test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      timestamp = data["status"]["timestamp"]
      # Should not raise
      parsed = Time.parse(timestamp)
      parsed.should.be.kind_of Time
    end
  end

  # --- Full pattern validation ---

  describe "when validating timestamp format" do
    it "should match ISO 8601 pattern with milliseconds" do
      task = create_task!(text: "Pattern test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      timestamp = data["status"]["timestamp"]
      # Allow both with and without milliseconds
      valid_pattern = /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z\z/
      timestamp.should.match(valid_pattern)
    end
  end

  # --- Timezone Restrictions ---

  describe "when validating timezone in timestamps" do
    it "should not include timezone offsets other than Z" do
      task = create_task!(text: "No offset test")
      response = http_get("/tasks/#{task["id"]}")
      data = parse_json(response)

      timestamp = data["status"]["timestamp"]
      # Should not have +HH:MM or -HH:MM offsets
      timestamp.should.not.match(/[+-]\d{2}:\d{2}\z/)
    end
  end
end
