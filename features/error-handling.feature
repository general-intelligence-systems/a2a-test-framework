Feature: Error Handling (Section 3.3.2)
  All operations may return errors. Servers MUST return appropriate errors
  and SHOULD provide actionable information to help clients resolve issues.

  # --- Authentication Errors ---

  Scenario: Server rejects request with missing authentication credentials
    Given a valid A2A server that requires authentication
    When a client sends a request without authentication credentials
    Then the server MUST reject the request with an authentication error

  Scenario: Server rejects request with invalid authentication credentials
    Given a valid A2A server that requires authentication
    When a client sends a request with invalid authentication credentials
    Then the server MUST reject the request with an authentication error

  Scenario: Authentication error response should include challenge information
    Given a valid A2A server that requires authentication
    When a client sends a request without authentication credentials
    Then the error response SHOULD include authentication challenge information

  Scenario: Authentication error response should specify required scheme
    Given a valid A2A server that requires authentication
    When a client sends a request without authentication credentials
    Then the error response SHOULD specify which authentication scheme is required

  Scenario: Server rejects request with expired credentials
    Given a valid A2A server that requires authentication
    When a client sends a request with an expired bearer token
    Then the server MUST reject the request with an authentication error

  # --- Authorization Errors ---

  Scenario: Server returns authorization error for insufficient permissions
    Given a valid A2A server
    And a client is authenticated but lacks required permissions for an operation
    When the client sends a request for that operation
    Then the server MUST return an authorization error

  Scenario: Authorization error should indicate missing permission or scope
    Given a valid A2A server
    And a client is authenticated with insufficient OAuth scopes
    When the client sends a request requiring higher scopes
    Then the error response SHOULD indicate what permission or scope is missing

  Scenario: Authorization error must not reveal existence of unauthorized resources
    Given a valid A2A server
    And a task exists belonging to another client
    When an authenticated client attempts to access that task
    Then the server MUST NOT reveal the existence of that task
    And the server MUST NOT distinguish between "does not exist" and "not authorized"

  # --- Validation Errors ---

  Scenario: Server validates all input parameters before processing
    Given a valid A2A server
    When a client sends a request with an invalid parameter format
    Then the server MUST return a validation error before attempting to process the request

  Scenario: Validation error should specify which parameter failed
    Given a valid A2A server
    When a client sends a request with an invalid task ID format
    Then the error response SHOULD specify which parameter failed validation
    And the error response SHOULD explain why it failed

  Scenario: Validation error should provide guidance on valid values
    Given a valid A2A server
    When a client sends a request with an invalid parameter
    Then the error response SHOULD provide guidance on valid parameter values or formats

  Scenario: Missing required message parts returns validation error
    Given a valid A2A server
    When a client sends a SendMessageRequest with no message parts
    Then the server MUST return a validation error

  # --- Resource Errors ---

  Scenario: Server returns not found error for non-existent resource
    Given a valid A2A server
    When a client requests a resource that does not exist
    Then the server MUST return a not found error

  Scenario: Server returns not found error for inaccessible resource
    Given a valid A2A server
    And a resource exists that is not accessible to the authenticated client
    When the client requests that resource
    Then the server MUST return a not found error

  Scenario: Server does not distinguish non-existent from unauthorized
    Given a valid A2A server
    When a client requests a task that does not exist
    And another client requests a task they are not authorized to access
    Then both responses SHOULD NOT be distinguishable to prevent information leakage

  # --- System Errors ---

  Scenario: Server returns appropriate error code for temporary failures
    Given a valid A2A server experiencing a temporary internal failure
    When a client sends a request
    Then the server SHOULD return an appropriate error code indicating temporary unavailability

  Scenario: Server may include retry guidance for temporary failures
    Given a valid A2A server experiencing a temporary internal failure
    When a client sends a request
    Then the error response MAY include retry guidance

  # --- Error Payload Structure ---

  Scenario: Error response contains error code
    Given a valid A2A server
    When a client sends a request that triggers an error
    Then the error response MUST contain an error code as a machine-readable identifier

  Scenario: Error response contains error message
    Given a valid A2A server
    When a client sends a request that triggers an error
    Then the error response MUST contain a human-readable error message

  Scenario: Error details objects include @type key
    Given a valid A2A server
    When a client sends a request that triggers an error with details
    Then each object in the error details array MUST include a "@type" key
    And the "@type" key MUST identify the object's type using ProtoJSON Any representation

  # --- A2A-Specific Errors ---

  Scenario: TaskNotFoundError for invalid task ID
    Given a valid A2A server
    When a client sends a request with a task ID that does not correspond to an existing task
    Then the server MUST return a TaskNotFoundError

  Scenario: TaskNotFoundError for expired task ID
    Given a valid A2A server
    And a task existed but has been purged
    When a client sends a request with that expired task ID
    Then the server MUST return a TaskNotFoundError

  Scenario: TaskNotCancelableError for completed task
    Given a valid A2A server
    And a task exists with status "completed"
    When a client sends a CancelTask request for that task
    Then the server MUST return a TaskNotCancelableError

  Scenario: TaskNotCancelableError for failed task
    Given a valid A2A server
    And a task exists with status "failed"
    When a client sends a CancelTask request for that task
    Then the server MUST return a TaskNotCancelableError

  Scenario: TaskNotCancelableError for already canceled task
    Given a valid A2A server
    And a task exists with status "canceled"
    When a client sends a CancelTask request for that task
    Then the server MUST return a TaskNotCancelableError

  Scenario: PushNotificationNotSupportedError when push not supported
    Given a valid A2A server that does NOT support push notifications
    When a client attempts to use push notification features
    Then the server MUST return a PushNotificationNotSupportedError

  Scenario: UnsupportedOperationError for unsupported operation
    Given a valid A2A server
    When a client requests an operation not supported by the agent
    Then the server MUST return an UnsupportedOperationError

  Scenario: ContentTypeNotSupportedError for unsupported media type
    Given a valid A2A server
    When a client sends a message with a Part containing an unsupported media type
    Then the server MUST return a ContentTypeNotSupportedError

  Scenario: InvalidAgentResponseError for non-conforming response
    Given an A2A agent that returns malformed responses
    When a response does not conform to the specification
    Then the error MUST be classified as InvalidAgentResponseError

  Scenario: ExtendedAgentCardNotConfiguredError when extended card not configured
    Given a valid A2A server with extendedAgentCard capability declared as true
    But the agent has not actually configured an extended card
    When a client requests the extended agent card
    Then the server MUST return an ExtendedAgentCardNotConfiguredError

  Scenario: ExtensionSupportRequiredError when required extension not declared by client
    Given a valid A2A server
    And the AgentCard lists an extension with required set to true
    When a client sends a request without declaring support for that extension in A2A-Extensions
    Then the server MUST return an ExtensionSupportRequiredError

  Scenario: VersionNotSupportedError when protocol version is unsupported
    Given a valid A2A server
    When a client sends a request with A2A-Version set to an unsupported version
    Then the server MUST return a VersionNotSupportedError
