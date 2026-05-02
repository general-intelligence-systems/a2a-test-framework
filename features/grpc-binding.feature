Feature: gRPC Protocol Binding (Section 10)
  High-performance gRPC binding using Protocol Buffers over HTTP/2.

  # --- Protocol Requirements (10.1) ---

  Scenario: gRPC binding uses HTTP/2 with TLS
    Given an A2A server using the gRPC binding
    Then the server MUST use gRPC over HTTP/2 with TLS

  Scenario: gRPC binding uses Protocol Buffers version 3
    Given an A2A server using the gRPC binding
    Then serialization MUST use Protocol Buffers version 3

  Scenario: gRPC binding implements A2AService
    Given an A2A server using the gRPC binding
    Then the server MUST implement the A2AService gRPC service

  # --- Service Parameter Transmission (10.2) ---

  Scenario: Service parameters transmitted as gRPC metadata
    Given an A2A server using the gRPC binding
    When a client sends a request with A2A service parameters
    Then the service parameters MUST be transmitted using gRPC metadata (headers)

  Scenario: Service parameter names transmitted as gRPC metadata keys
    Given an A2A server using the gRPC binding
    When a client includes the A2A-Version service parameter
    Then it MUST be transmitted as a gRPC metadata key

  Scenario: Multiple extension values comma-separated in single metadata entry
    Given an A2A server using the gRPC binding
    When a client uses multiple extensions
    Then the values SHOULD be comma-separated in a single metadata entry

  Scenario: Server must extract service parameters from gRPC metadata
    Given an A2A server using the gRPC binding
    When a request includes A2A service parameters in gRPC metadata
    Then the server MUST extract A2A service parameters from the metadata for processing

  Scenario: Server should validate required service parameters from metadata
    Given an A2A server using the gRPC binding
    When a request is received
    Then the server SHOULD validate required service parameters (e.g., A2A-Version) from metadata

  # --- Error Handling (10.6) ---

  Scenario: gRPC errors use standard gRPC status structure
    Given an A2A server using the gRPC binding
    When an error occurs
    Then the response MUST use the standard gRPC status structure (google.rpc.Status)

  Scenario: Error code mapped to gRPC status code
    Given an A2A server using the gRPC binding
    When an error occurs
    Then the error code MUST be mapped to the status.code field (gRPC status code enum)

  Scenario: Error message mapped to status.message
    Given an A2A server using the gRPC binding
    When an error occurs
    Then the error message MUST be in the status.message field

  Scenario: A2A errors must include google.rpc.ErrorInfo in details
    Given an A2A server using the gRPC binding
    When an A2A-specific error occurs
    Then the status.details array MUST include a google.rpc.ErrorInfo message

  Scenario: ErrorInfo reason uses UPPER_SNAKE_CASE without Error suffix
    Given an A2A server using the gRPC binding
    When a TaskNotFoundError occurs
    Then the ErrorInfo reason MUST be "TASK_NOT_FOUND"

  Scenario: ErrorInfo domain set to a2a-protocol.org
    Given an A2A server using the gRPC binding
    When an A2A-specific error occurs
    Then the ErrorInfo domain MUST be set to "a2a-protocol.org"

  # --- Streaming (10.7) ---

  Scenario: gRPC streaming uses server streaming RPCs
    Given an A2A server using the gRPC binding
    When a streaming operation is invoked
    Then the server MUST use server streaming RPCs for real-time updates
