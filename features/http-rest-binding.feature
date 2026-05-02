Feature: HTTP+JSON/REST Protocol Binding (Section 11)
  RESTful interface using standard HTTP methods and JSON payloads.

  # --- Protocol Requirements (11.1) ---

  Scenario: Content-Type should be application/a2a+json
    Given an A2A server using the HTTP/REST binding
    When a client sends a request or receives a response
    Then the Content-Type SHOULD be "application/a2a+json"

  # --- Service Parameter Transmission (11.2) ---

  Scenario: Service parameters transmitted as HTTP headers
    Given an A2A server using the HTTP/REST binding
    When a client sends a request with A2A service parameters
    Then the service parameters MUST be transmitted using standard HTTP request headers

  Scenario: Multiple extension values comma-separated in single header
    Given an A2A server using the HTTP/REST binding
    When a client uses multiple extensions
    Then the values SHOULD be comma-separated in a single A2A-Extensions header field

  # --- URL Patterns (11.3) ---

  Scenario: POST /message:send for Send Message
    Given an A2A server using the HTTP/REST binding
    When a client sends a message
    Then the endpoint MUST be POST /message:send

  Scenario: POST /message:stream for streaming message
    Given an A2A server using the HTTP/REST binding
    When a client sends a streaming message
    Then the endpoint MUST be POST /message:stream

  Scenario: GET /tasks/{id} for Get Task
    Given an A2A server using the HTTP/REST binding
    When a client retrieves a task
    Then the endpoint MUST be GET /tasks/{id}

  Scenario: GET /tasks for List Tasks
    Given an A2A server using the HTTP/REST binding
    When a client lists tasks
    Then the endpoint MUST be GET /tasks

  Scenario: POST /tasks/{id}:cancel for Cancel Task
    Given an A2A server using the HTTP/REST binding
    When a client cancels a task
    Then the endpoint MUST be POST /tasks/{id}:cancel

  Scenario: POST /tasks/{id}:subscribe for Subscribe to Task
    Given an A2A server using the HTTP/REST binding
    When a client subscribes to a task
    Then the endpoint MUST be POST /tasks/{id}:subscribe

  # --- Query Parameter Naming (11.5) ---

  Scenario: Query parameters must use camelCase
    Given an A2A server using the HTTP/REST binding
    When a client sends a GET request with query parameters
    Then query parameter names MUST use camelCase

  Scenario: context_id field uses contextId query parameter
    Given an A2A server using the HTTP/REST binding
    When a client filters tasks by context
    Then the query parameter MUST be "contextId" not "context_id"

  Scenario: page_size field uses pageSize query parameter
    Given an A2A server using the HTTP/REST binding
    When a client specifies page size
    Then the query parameter MUST be "pageSize" not "page_size"

  Scenario: Boolean query parameters use lowercase strings
    Given an A2A server using the HTTP/REST binding
    When a client passes a boolean query parameter
    Then the value MUST be represented as "true" or "false" (lowercase)

  Scenario: Enum query parameters use string values
    Given an A2A server using the HTTP/REST binding
    When a client filters tasks by status
    Then the value MUST be the enum string value

  Scenario: Query parameter values must be URL-encoded per RFC 3986
    Given an A2A server using the HTTP/REST binding
    When a client sends query parameters with special characters
    Then all values MUST be properly URL-encoded per RFC 3986

  Scenario: Nested objects not supported in query parameters
    Given an A2A server using the HTTP/REST binding
    Then operations requiring nested objects MUST use POST with a request body

  # --- Error Handling (11.6) ---

  Scenario: Error responses use google.rpc.Status JSON representation
    Given an A2A server using the HTTP/REST binding
    When an error occurs
    Then the response MUST use the google.rpc.Status JSON representation

  Scenario: Error details objects must include @type key
    Given an A2A server using the HTTP/REST binding
    When an error response includes details
    Then each object in the details array MUST include a "@type" key

  Scenario: A2A errors must include ErrorInfo with reason and domain
    Given an A2A server using the HTTP/REST binding
    When an A2A-specific error occurs
    Then the details MUST include a google.rpc.ErrorInfo object
    And the reason MUST be in UPPER_SNAKE_CASE without "Error" suffix
    And the domain MUST be set to "a2a-protocol.org"

  Scenario: TaskNotFound error returns HTTP 404 with ErrorInfo
    Given an A2A server using the HTTP/REST binding
    When a TaskNotFoundError occurs
    Then the HTTP status MUST be 404
    And the ErrorInfo reason MUST be "TASK_NOT_FOUND"

  Scenario: Multiple A2A errors mapping to same HTTP status are distinguishable
    Given an A2A server using the HTTP/REST binding
    When TaskNotCancelableError and PushNotificationNotSupportedError both map to 400
    Then the ErrorInfo reason MUST distinguish between them
    And "TASK_NOT_CANCELABLE" vs "PUSH_NOTIFICATION_NOT_SUPPORTED" in the reason field

  # --- Streaming (11.7) ---

  Scenario: Streaming uses Server-Sent Events
    Given an A2A server using the HTTP/REST binding
    When a streaming operation is invoked
    Then the response MUST use Server-Sent Events with Content-Type text/event-stream

  Scenario: SSE data field contains JSON StreamResponse objects
    Given an A2A server using the HTTP/REST binding
    When streaming events are delivered
    Then each event's "data" field MUST contain a JSON serialization of a StreamResponse object
