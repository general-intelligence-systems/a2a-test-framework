Feature: Timestamp Conventions (Section 5.6.1)
  All timestamps MUST be ISO 8601 formatted strings in UTC timezone.

  # --- Format Requirements ---

  Scenario: Timestamps in JSON must be ISO 8601 format
    Given a valid A2A server using a JSON-based binding
    When the server returns a response containing timestamp fields
    Then all timestamps MUST be represented as ISO 8601 formatted strings

  Scenario: Timestamps must use UTC timezone with Z suffix
    Given a valid A2A server using a JSON-based binding
    When the server returns a response containing timestamp fields
    Then all timestamps MUST use UTC timezone denoted by 'Z' suffix

  Scenario: Timestamps should use millisecond precision
    Given a valid A2A server using a JSON-based binding
    When the server returns a response containing timestamp fields
    Then timestamps SHOULD use millisecond precision where available

  Scenario: Timestamp follows pattern YYYY-MM-DDTHH:mm:ss.sssZ
    Given a valid A2A server using a JSON-based binding
    When the server returns a task with a timestamp
    Then the timestamp MUST match the pattern "YYYY-MM-DDTHH:mm:ss.sssZ"

  # --- Parsing and Generation ---

  Scenario: Server must generate ISO 8601 timestamps correctly
    Given a valid A2A server using a JSON-based binding
    When the server returns any response with timestamps
    Then the timestamps MUST be valid ISO 8601 strings parseable by standard date libraries

  Scenario: Client must parse ISO 8601 timestamps correctly
    Given a valid A2A client
    When the client receives a response with timestamp "2025-10-28T10:30:00.000Z"
    Then the client MUST parse it as a valid ISO 8601 timestamp

  # --- Timezone Restrictions ---

  Scenario: Timestamps must not include timezone offsets other than Z
    Given a valid A2A server using a JSON-based binding
    When the server returns a response containing timestamp fields
    Then timestamps MUST NOT include timezone offsets like "+05:30" or "-08:00"
    And all timestamps MUST use 'Z' suffix only

  # --- Precision Flexibility ---

  Scenario: Fractional seconds may be omitted when not available
    Given a valid A2A server using a JSON-based binding
    When millisecond precision is not available for a timestamp
    Then the fractional seconds portion MAY be omitted
    And "2025-10-28T10:30:00Z" is a valid timestamp

  Scenario: Fractional seconds may be zero-filled
    Given a valid A2A server using a JSON-based binding
    When millisecond precision is not available for a timestamp
    Then the fractional seconds MAY be zero-filled
    And "2025-10-28T10:30:00.000Z" is a valid timestamp
