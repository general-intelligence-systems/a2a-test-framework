Feature: Functional Equivalence Requirements (Section 5.1)
  When an agent supports multiple protocols, all supported protocols
  MUST meet equivalence requirements.

  Scenario: All supported protocols must provide identical functionality
    Given a valid A2A server supporting both JSON-RPC and gRPC bindings
    Then both bindings MUST provide the same set of operations and capabilities

  Scenario: All supported protocols must return semantically equivalent results
    Given a valid A2A server supporting both JSON-RPC and HTTP/REST bindings
    When the same request is sent via JSON-RPC and HTTP/REST
    Then both MUST return semantically equivalent results

  Scenario: All supported protocols must map errors consistently
    Given a valid A2A server supporting multiple protocol bindings
    When the same invalid request is sent via each binding
    Then each MUST return errors mapped consistently using appropriate protocol-specific codes

  Scenario: All supported protocols must support the same authentication schemes
    Given a valid A2A server supporting multiple protocol bindings
    And the AgentCard declares specific authentication schemes
    Then all protocol bindings MUST support the same authentication schemes
