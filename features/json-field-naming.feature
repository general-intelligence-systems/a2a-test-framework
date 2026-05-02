Feature: JSON Field Naming Convention (Section 5.5)
  All JSON serializations MUST use camelCase naming for field names.
  Enum values MUST follow ProtoJSON specification.

  # --- camelCase Field Names ---

  Scenario: JSON fields use camelCase not snake_case
    Given a valid A2A server using a JSON-based binding
    When the server returns a response
    Then all field names MUST be in camelCase format

  Scenario: protocol_version proto field serialized as protocolVersion
    Given a valid A2A server using a JSON-based binding
    When the server returns a response containing a protocol version field
    Then the field MUST be named "protocolVersion" not "protocol_version"

  Scenario: context_id proto field serialized as contextId
    Given a valid A2A server using a JSON-based binding
    When the server returns a Task with a context identifier
    Then the field MUST be named "contextId" not "context_id"

  Scenario: default_input_modes proto field serialized as defaultInputModes
    Given a valid A2A server using a JSON-based binding
    When the server returns an AgentCard
    Then the field MUST be named "defaultInputModes" not "default_input_modes"

  Scenario: push_notification_config proto field serialized as pushNotificationConfig
    Given a valid A2A server using a JSON-based binding
    When the server returns push notification configuration data
    Then the field MUST be named "pushNotificationConfig" not "push_notification_config"

  Scenario: Server rejects requests with snake_case field names
    Given a valid A2A server using a JSON-based binding
    When a client sends a request using snake_case field names
    Then the server SHOULD treat these as unrecognized fields

  # --- Enum Values ---

  Scenario: Enum values use string names as defined in proto (SCREAMING_SNAKE_CASE)
    Given a valid A2A server using a JSON-based binding
    When the server returns a response with enum values
    Then enum values MUST be represented as their string names from the Proto definition

  Scenario: TASK_STATE_INPUT_REQUIRED enum value serialized correctly
    Given a valid A2A server using a JSON-based binding
    When the server returns a task in input_required state
    Then the state value MUST be "TASK_STATE_INPUT_REQUIRED"

  Scenario: ROLE_USER enum value serialized correctly
    Given a valid A2A server using a JSON-based binding
    When the server returns a Message with user role
    Then the role value MUST be "ROLE_USER"
