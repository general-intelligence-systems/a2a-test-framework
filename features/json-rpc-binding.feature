Feature: JSON-RPC Protocol Binding (Section 9)
  JSON-RPC 2.0 over HTTP(S) with SSE for streaming.

  # --- Protocol Requirements (9.1) ---

  Scenario: Requests use Content-Type application/json
    Given an A2A server using the JSON-RPC binding
    When a client sends a request
    Then the request Content-Type MUST be "application/json"

  Scenario: Responses use Content-Type application/json
    Given an A2A server using the JSON-RPC binding
    When the server returns a non-streaming response
    Then the response Content-Type MUST be "application/json"

  Scenario: Streaming responses use Content-Type text/event-stream
    Given an A2A server using the JSON-RPC binding
    When a client sends a SendStreamingMessage or SubscribeToTask request
    Then the response Content-Type MUST be "text/event-stream"

  # --- Service Parameter Transmission (9.2) ---

  Scenario: Service parameters transmitted as HTTP headers
    Given an A2A server using the JSON-RPC binding
    When a client sends a request with A2A-Version service parameter
    Then the service parameter MUST be transmitted as an HTTP header field

  Scenario: Multiple extension values comma-separated in single header
    Given an A2A server using the JSON-RPC binding
    When a client uses multiple extensions
    Then the values SHOULD be comma-separated in a single A2A-Extensions header field

  # --- Base Request Structure (9.3) ---

  Scenario: Request must follow JSON-RPC 2.0 format
    Given an A2A server using the JSON-RPC binding
    When a client sends a request
    Then the request MUST include "jsonrpc" field set to "2.0"
    And the request MUST include an "id" field
    And the request MUST include a "method" field
    And the request MUST include a "params" field

  Scenario: Method names use PascalCase
    Given an A2A server using the JSON-RPC binding
    Then method names MUST use PascalCase (e.g., "SendMessage", "GetTask")

  # --- Streaming via SSE (9.4.2) ---

  Scenario: SendStreamingMessage returns SSE stream
    Given an A2A server using the JSON-RPC binding
    When a client sends a SendStreamingMessage request
    Then the response MUST be HTTP 200 with Content-Type text/event-stream
    And each event MUST be a JSON-RPC response object in a "data:" field

  Scenario: SubscribeToTask returns SSE stream
    Given an A2A server using the JSON-RPC binding
    When a client sends a SubscribeToTask request
    Then the response MUST be an SSE stream (same format as SendStreamingMessage)

  # --- Error Handling (9.5) ---

  Scenario: Error response uses standard JSON-RPC 2.0 error object
    Given an A2A server using the JSON-RPC binding
    When an error occurs
    Then the response MUST contain an "error" object
    And the error object MUST contain a numeric "code" field
    And the error object MUST contain a string "message" field

  Scenario: Error data array objects must include @type key
    Given an A2A server using the JSON-RPC binding
    When an error response includes detailed error information
    Then each object in the "data" array MUST include a "@type" key

  Scenario: JSONParseError uses code -32700
    Given an A2A server using the JSON-RPC binding
    When the server receives invalid JSON
    Then the error code MUST be -32700

  Scenario: InvalidRequestError uses code -32600
    Given an A2A server using the JSON-RPC binding
    When the JSON is not a valid JSON-RPC Request object
    Then the error code MUST be -32600

  Scenario: MethodNotFoundError uses code -32601
    Given an A2A server using the JSON-RPC binding
    When the requested method does not exist
    Then the error code MUST be -32601

  Scenario: InvalidParamsError uses code -32602
    Given an A2A server using the JSON-RPC binding
    When method parameters are invalid
    Then the error code MUST be -32602

  Scenario: InternalError uses code -32603
    Given an A2A server using the JSON-RPC binding
    When an internal server error occurs
    Then the error code MUST be -32603

  Scenario: A2A-specific errors use codes in range -32001 to -32099
    Given an A2A server using the JSON-RPC binding
    When an A2A-specific error occurs
    Then the error code MUST be in the range -32001 to -32099
