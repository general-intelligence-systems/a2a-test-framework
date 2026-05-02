# frozen_string_literal: true

require_relative "a2a_test_framework/version"

module A2ATestFramework
  # Root directory of the gem (for locating test files, schemas, etc.)
  ROOT = File.expand_path("..", __dir__)

  # Directory containing the test files
  TESTS_DIR = File.join(ROOT, "tests")

  # Directory containing endpoint JSON schemas
  ENDPOINTS_DIR = File.join(ROOT, "endpoints")

  # Path to the protocol schema bundle
  SCHEMA_PATH = File.join(ROOT, "a2a.json")
end
