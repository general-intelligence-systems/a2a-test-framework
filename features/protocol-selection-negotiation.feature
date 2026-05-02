Feature: Protocol Selection and Negotiation (Section 5.2)
  Agents declare supported protocols; clients choose which to use.

  Scenario: Agent must declare all supported protocols in AgentCard
    Given a valid A2A server supporting JSON-RPC and gRPC
    Then the AgentCard MUST declare both JSON-RPC and gRPC as supported protocols

  Scenario: Agent must not support undeclared protocols
    Given a valid A2A server
    And the AgentCard does not declare gRPC as a supported protocol
    Then the agent is not required to respond to gRPC requests

  Scenario: Client may choose any protocol declared by the agent
    Given a valid A2A server declaring JSON-RPC and HTTP/REST in the AgentCard
    When a client chooses to use HTTP/REST
    Then the agent MUST accept requests via HTTP/REST

  Scenario: Client should implement fallback logic for alternative protocols
    Given a valid A2A server declaring multiple protocol bindings
    When the client's preferred protocol is unavailable
    Then the client SHOULD implement fallback logic to try alternative declared protocols
