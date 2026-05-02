Feature: Error Code Mappings (Section 5.4)
  All A2A-specific errors MUST be mapped to binding-specific error representations.

  # --- JSON-RPC Error Code Mappings ---

  Scenario: TaskNotFoundError maps to JSON-RPC code -32001
    Given an A2A server using the JSON-RPC binding
    When a TaskNotFoundError occurs
    Then the JSON-RPC error code MUST be -32001

  Scenario: TaskNotCancelableError maps to JSON-RPC code -32002
    Given an A2A server using the JSON-RPC binding
    When a TaskNotCancelableError occurs
    Then the JSON-RPC error code MUST be -32002

  Scenario: PushNotificationNotSupportedError maps to JSON-RPC code -32003
    Given an A2A server using the JSON-RPC binding
    When a PushNotificationNotSupportedError occurs
    Then the JSON-RPC error code MUST be -32003

  Scenario: UnsupportedOperationError maps to JSON-RPC code -32004
    Given an A2A server using the JSON-RPC binding
    When an UnsupportedOperationError occurs
    Then the JSON-RPC error code MUST be -32004

  Scenario: ContentTypeNotSupportedError maps to JSON-RPC code -32005
    Given an A2A server using the JSON-RPC binding
    When a ContentTypeNotSupportedError occurs
    Then the JSON-RPC error code MUST be -32005

  Scenario: InvalidAgentResponseError maps to JSON-RPC code -32006
    Given an A2A server using the JSON-RPC binding
    When an InvalidAgentResponseError occurs
    Then the JSON-RPC error code MUST be -32006

  Scenario: ExtendedAgentCardNotConfiguredError maps to JSON-RPC code -32007
    Given an A2A server using the JSON-RPC binding
    When an ExtendedAgentCardNotConfiguredError occurs
    Then the JSON-RPC error code MUST be -32007

  Scenario: ExtensionSupportRequiredError maps to JSON-RPC code -32008
    Given an A2A server using the JSON-RPC binding
    When an ExtensionSupportRequiredError occurs
    Then the JSON-RPC error code MUST be -32008

  Scenario: VersionNotSupportedError maps to JSON-RPC code -32009
    Given an A2A server using the JSON-RPC binding
    When a VersionNotSupportedError occurs
    Then the JSON-RPC error code MUST be -32009

  # --- gRPC Status Mappings ---

  Scenario: TaskNotFoundError maps to gRPC NOT_FOUND
    Given an A2A server using the gRPC binding
    When a TaskNotFoundError occurs
    Then the gRPC status MUST be NOT_FOUND

  Scenario: TaskNotCancelableError maps to gRPC FAILED_PRECONDITION
    Given an A2A server using the gRPC binding
    When a TaskNotCancelableError occurs
    Then the gRPC status MUST be FAILED_PRECONDITION

  Scenario: PushNotificationNotSupportedError maps to gRPC FAILED_PRECONDITION
    Given an A2A server using the gRPC binding
    When a PushNotificationNotSupportedError occurs
    Then the gRPC status MUST be FAILED_PRECONDITION

  Scenario: UnsupportedOperationError maps to gRPC FAILED_PRECONDITION
    Given an A2A server using the gRPC binding
    When an UnsupportedOperationError occurs
    Then the gRPC status MUST be FAILED_PRECONDITION

  Scenario: ContentTypeNotSupportedError maps to gRPC INVALID_ARGUMENT
    Given an A2A server using the gRPC binding
    When a ContentTypeNotSupportedError occurs
    Then the gRPC status MUST be INVALID_ARGUMENT

  Scenario: InvalidAgentResponseError maps to gRPC INTERNAL
    Given an A2A server using the gRPC binding
    When an InvalidAgentResponseError occurs
    Then the gRPC status MUST be INTERNAL

  # --- HTTP Status Mappings ---

  Scenario: TaskNotFoundError maps to HTTP 404
    Given an A2A server using the HTTP/REST binding
    When a TaskNotFoundError occurs
    Then the HTTP status MUST be 404 Not Found

  Scenario: TaskNotCancelableError maps to HTTP 400
    Given an A2A server using the HTTP/REST binding
    When a TaskNotCancelableError occurs
    Then the HTTP status MUST be 400 Bad Request

  Scenario: ContentTypeNotSupportedError maps to HTTP 400
    Given an A2A server using the HTTP/REST binding
    When a ContentTypeNotSupportedError occurs
    Then the HTTP status MUST be 400 Bad Request

  Scenario: InvalidAgentResponseError maps to HTTP 500
    Given an A2A server using the HTTP/REST binding
    When an InvalidAgentResponseError occurs
    Then the HTTP status MUST be 500 Internal Server Error

  # --- Custom Binding Requirements ---

  Scenario: Custom bindings must define equivalent error code mappings
    Given an A2A server using a custom protocol binding
    Then the binding MUST define equivalent error code mappings
    And the mappings MUST preserve the semantic meaning of each A2A error type
