Feature: Protocol Data Model (Section 4)
  The A2A protocol defines a canonical data model using Protocol Buffers.
  All protocol bindings MUST provide functionally equivalent representations.

  Scenario: JSON-RPC binding provides functionally equivalent data structures
    Given an A2A server using the JSON-RPC protocol binding
    Then the binding MUST provide functionally equivalent representations of all protocol data structures

  Scenario: gRPC binding provides functionally equivalent data structures
    Given an A2A server using the gRPC protocol binding
    Then the binding MUST provide functionally equivalent representations of all protocol data structures

  Scenario: HTTP/REST binding provides functionally equivalent data structures
    Given an A2A server using the HTTP/REST protocol binding
    Then the binding MUST provide functionally equivalent representations of all protocol data structures

  Scenario: Custom binding provides functionally equivalent data structures
    Given an A2A server using a custom protocol binding
    Then the binding MUST provide functionally equivalent representations of all protocol data structures
