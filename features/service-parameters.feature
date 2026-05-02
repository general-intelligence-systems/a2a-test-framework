Feature: Service Parameters (Section 3.2.6)
  A key-value map for passing horizontally applicable context or parameters.
  Keys are case-insensitive strings, values are case-sensitive strings.

  # --- Key Case Insensitivity ---

  Scenario: Service parameter keys are case-insensitive
    Given a valid A2A server
    When a client sends a request with service parameter key "A2A-Version"
    And another request with service parameter key "a2a-version"
    Then both requests MUST be treated as specifying the same parameter

  Scenario: Service parameter keys in mixed case are equivalent
    Given a valid A2A server
    When a client sends a request with service parameter key "A2A-Extensions"
    And another request with service parameter key "a2a-extensions"
    Then both requests MUST be treated as specifying the same parameter

  # --- Value Case Sensitivity ---

  Scenario: Service parameter values are case-sensitive
    Given a valid A2A server
    When a client sends a request with A2A-Version value "1.0"
    Then the server MUST treat the value as exactly "1.0"
    And MUST NOT treat "1.0" and "1.0" differently only if they are identical strings

  # --- A2A-Version Parameter ---

  Scenario: VersionNotSupportedError when A2A-Version is unsupported
    Given a valid A2A server
    When a client sends a request with A2A-Version set to an unsupported version
    Then the server MUST respond with a VersionNotSupportedError

  Scenario: A2A-Version with supported version is accepted
    Given a valid A2A server
    When a client sends a request with A2A-Version set to a supported version
    Then the server MUST process the request normally

  # --- A2A-Extensions Parameter ---

  Scenario: A2A-Extensions contains comma-separated list of extension URIs
    Given a valid A2A server
    When a client sends a request with A2A-Extensions set to "https://example.com/ext1,https://example.com/ext2"
    Then the server MUST interpret the value as a comma-separated list of extension URIs

  # --- Prefix Convention ---

  Scenario: All specification-defined service parameters are prefixed with a2a-
    Given the A2A protocol specification
    Then all service parameters defined by the specification MUST be prefixed with "a2a-"
