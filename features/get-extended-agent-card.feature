Feature: Get Extended Agent Card Operation (Section 3.1.11)
  Retrieves a potentially more detailed version of the Agent Card after
  the client has authenticated. Available only if
  AgentCard.capabilities.extendedAgentCard is true.

  # --- Authentication Requirement ---

  Scenario: Client must authenticate using declared security schemes
    Given a valid A2A server with extendedAgentCard capability enabled
    And the public AgentCard declares securitySchemes and security fields
    When a client sends an authenticated GetExtendedAgentCard request using a declared scheme
    Then the server MUST accept the request

  Scenario: Unauthenticated request is rejected
    Given a valid A2A server with extendedAgentCard capability enabled
    When a client sends a GetExtendedAgentCard request without authentication
    Then the server MUST reject the request with an authentication error

  Scenario: Request authenticated with undeclared scheme is rejected
    Given a valid A2A server with extendedAgentCard capability enabled
    When a client sends a GetExtendedAgentCard request using a scheme not declared in the AgentCard
    Then the server MUST reject the request

  # --- Successful Retrieval ---

  Scenario: Successfully retrieve extended agent card
    Given a valid A2A server with extendedAgentCard capability enabled
    And the client is properly authenticated
    When a client sends a GetExtendedAgentCard request
    Then the server MUST respond with a complete AgentCard object

  Scenario: Extended card may contain additional skills not in public card
    Given a valid A2A server with extendedAgentCard capability enabled
    And the agent has additional skills only available to authenticated clients
    When an authenticated client sends a GetExtendedAgentCard request
    Then the response AgentCard MAY contain additional skills not present in the public card

  Scenario: Extended card may contain additional capabilities not in public card
    Given a valid A2A server with extendedAgentCard capability enabled
    And the agent has additional capabilities only available to authenticated clients
    When an authenticated client sends a GetExtendedAgentCard request
    Then the response AgentCard MAY contain additional capabilities not in the public card

  Scenario: Response may vary based on client authentication level
    Given a valid A2A server with extendedAgentCard capability enabled
    When a client with basic authentication sends a GetExtendedAgentCard request
    And a client with elevated authentication sends a GetExtendedAgentCard request
    Then the two responses MAY contain different details based on authentication level

  # --- Card Replacement Behavior ---

  Scenario: Client should replace cached public card with extended card
    Given a valid A2A server with extendedAgentCard capability enabled
    And a client has previously cached the public AgentCard
    When the client retrieves the extended agent card
    Then the client SHOULD replace their cached public AgentCard with the extended card
    And the replacement SHOULD last for the duration of the authenticated session

  Scenario: Client should replace cached card until version changes
    Given a valid A2A server with extendedAgentCard capability enabled
    And a client has retrieved and cached the extended agent card
    When the agent card version changes
    Then the client SHOULD discard the cached extended card and re-fetch

  # --- Availability / Capability Validation ---

  Scenario: Operation available when extendedAgentCard capability is true
    Given a valid A2A server
    And the public AgentCard declares capabilities.extendedAgentCard as true
    When an authenticated client sends a GetExtendedAgentCard request
    Then the server MUST process the request

  Scenario: UnsupportedOperationError when extendedAgentCard capability is false
    Given a valid A2A server
    And the public AgentCard declares capabilities.extendedAgentCard as false
    When a client sends a GetExtendedAgentCard request
    Then the server MUST respond with an UnsupportedOperationError

  Scenario: UnsupportedOperationError when extendedAgentCard capability is not present
    Given a valid A2A server
    And the public AgentCard does not declare capabilities.extendedAgentCard
    When a client sends a GetExtendedAgentCard request
    Then the server MUST respond with an UnsupportedOperationError

  # --- Error Cases ---

  Scenario: ExtendedAgentCardNotConfiguredError when agent declares support but has no card
    Given a valid A2A server
    And the public AgentCard declares capabilities.extendedAgentCard as true
    But the agent has not configured an extended agent card
    When an authenticated client sends a GetExtendedAgentCard request
    Then the server MUST respond with an ExtendedAgentCardNotConfiguredError
