Feature: Agent Discovery - The Agent Card (Sections 8.1-8.3.2)
  A2A Servers MUST make an Agent Card available for discovery and configuration.

  # --- Purpose (8.1) ---

  Scenario: Server must make an Agent Card available
    Given a valid A2A server
    Then the server MUST make an Agent Card available
    And the Agent Card MUST describe the server's identity, capabilities, skills, and interaction requirements

  # --- Discovery Mechanisms (8.2) ---

  Scenario: Agent Card accessible via well-known URI
    Given a valid A2A server at domain "agent.example.com"
    When a client requests "https://agent.example.com/.well-known/agent-card.json"
    Then the server SHOULD return the Agent Card as JSON

  # --- Protocol Declaration Requirements (8.3) ---

  Scenario: AgentCard must properly declare supported protocols
    Given a valid A2A server supporting multiple protocols
    Then the AgentCard MUST properly declare all supported protocols

  # --- Supported Interfaces Declaration (8.3.1) ---

  Scenario: supportedInterfaces should declare all protocols in preference order
    Given a valid A2A server supporting JSON-RPC and HTTP/REST
    Then the supportedInterfaces field SHOULD declare all supported protocol combinations
    And they SHOULD be in preference order

  Scenario: First entry in supportedInterfaces is preferred interface
    Given a valid A2A server
    And the AgentCard has multiple entries in supportedInterfaces
    Then the first entry represents the preferred interface

  Scenario: Each interface must accurately declare its transport and URL
    Given a valid A2A server
    Then each interface entry in supportedInterfaces MUST accurately declare its transport protocol
    And each interface MUST accurately declare its URL

  # --- Client Protocol Selection (8.3.2) ---

  Scenario: Client must parse supportedInterfaces and select first supported transport
    Given a valid A2A client
    And an AgentCard with supportedInterfaces listing gRPC then HTTP/REST
    When the client supports both gRPC and HTTP/REST
    Then the client MUST select gRPC as it is first in the list

  Scenario: Client must prefer earlier entries in the ordered list
    Given a valid A2A client
    And an AgentCard with supportedInterfaces listing multiple options
    When the client supports multiple listed options
    Then the client MUST prefer earlier entries in the ordered list

  Scenario: Client must use the correct URL for selected transport
    Given a valid A2A client
    And an AgentCard with supportedInterfaces containing different URLs per transport
    When the client selects a transport
    Then the client MUST use the correct URL associated with that transport entry
