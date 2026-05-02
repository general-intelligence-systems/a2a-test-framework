Feature: Field Presence and Optionality (Section 5.7)
  Required fields MUST be present. Implementations SHOULD ignore unrecognized fields.

  # --- Required Fields ---

  Scenario: Required fields must be present in valid messages
    Given a valid A2A server
    When a client sends a message with all required fields present
    Then the server MUST accept the message as valid

  Scenario: Server rejects messages with missing required fields
    Given a valid A2A server
    When a client sends a message with a required field missing
    Then the server SHOULD reject the message with a validation error

  Scenario: Required arrays must contain at least one element
    Given a valid A2A server
    When a client sends a message with a required array field set to an empty array
    Then the server SHOULD reject the message
    Because required arrays MUST contain at least one element

  # --- Unrecognized Fields ---

  Scenario: Implementations should ignore unrecognized fields
    Given a valid A2A server
    When a client sends a request with an unrecognized extra field "futureField"
    Then the server SHOULD ignore the unrecognized field
    And the server SHOULD process the request normally

  Scenario: Forward compatibility through ignoring unknown fields
    Given a valid A2A server implementing version 1.0
    When a client sends a request containing fields from a future protocol version
    Then the server SHOULD ignore the unrecognized fields
    And the server SHOULD process the request based on known fields
