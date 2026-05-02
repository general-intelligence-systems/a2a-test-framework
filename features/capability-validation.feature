Feature: Capability Validation (Section 3.3.4)
  Agents declare optional capabilities in their AgentCard. When clients attempt
  to use operations requiring undeclared capabilities, the agent MUST return
  an appropriate error response.

  # --- Push Notifications Capability ---

  Scenario: PushNotificationNotSupportedError when pushNotifications is false - Create
    Given a valid A2A server
    And the AgentCard declares capabilities.pushNotifications as false
    When a client sends a CreatePushNotificationConfig request
    Then the server MUST return a PushNotificationNotSupportedError

  Scenario: PushNotificationNotSupportedError when pushNotifications is not present - Create
    Given a valid A2A server
    And the AgentCard does not declare capabilities.pushNotifications
    When a client sends a CreatePushNotificationConfig request
    Then the server MUST return a PushNotificationNotSupportedError

  Scenario: PushNotificationNotSupportedError when pushNotifications is false - Get
    Given a valid A2A server
    And the AgentCard declares capabilities.pushNotifications as false
    When a client sends a GetPushNotificationConfig request
    Then the server MUST return a PushNotificationNotSupportedError

  Scenario: PushNotificationNotSupportedError when pushNotifications is not present - Get
    Given a valid A2A server
    And the AgentCard does not declare capabilities.pushNotifications
    When a client sends a GetPushNotificationConfig request
    Then the server MUST return a PushNotificationNotSupportedError

  Scenario: PushNotificationNotSupportedError when pushNotifications is false - List
    Given a valid A2A server
    And the AgentCard declares capabilities.pushNotifications as false
    When a client sends a ListPushNotificationConfigs request
    Then the server MUST return a PushNotificationNotSupportedError

  Scenario: PushNotificationNotSupportedError when pushNotifications is not present - List
    Given a valid A2A server
    And the AgentCard does not declare capabilities.pushNotifications
    When a client sends a ListPushNotificationConfigs request
    Then the server MUST return a PushNotificationNotSupportedError

  Scenario: PushNotificationNotSupportedError when pushNotifications is false - Delete
    Given a valid A2A server
    And the AgentCard declares capabilities.pushNotifications as false
    When a client sends a DeletePushNotificationConfig request
    Then the server MUST return a PushNotificationNotSupportedError

  Scenario: PushNotificationNotSupportedError when pushNotifications is not present - Delete
    Given a valid A2A server
    And the AgentCard does not declare capabilities.pushNotifications
    When a client sends a DeletePushNotificationConfig request
    Then the server MUST return a PushNotificationNotSupportedError

  # --- Streaming Capability ---

  Scenario: UnsupportedOperationError when streaming is false - SendStreamingMessage
    Given a valid A2A server
    And the AgentCard declares capabilities.streaming as false
    When a client sends a SendStreamingMessage request
    Then the server MUST return an UnsupportedOperationError

  Scenario: UnsupportedOperationError when streaming is not present - SendStreamingMessage
    Given a valid A2A server
    And the AgentCard does not declare capabilities.streaming
    When a client sends a SendStreamingMessage request
    Then the server MUST return an UnsupportedOperationError

  Scenario: UnsupportedOperationError when streaming is false - SubscribeToTask
    Given a valid A2A server
    And the AgentCard declares capabilities.streaming as false
    When a client sends a SubscribeToTask request
    Then the server MUST return an UnsupportedOperationError

  Scenario: UnsupportedOperationError when streaming is not present - SubscribeToTask
    Given a valid A2A server
    And the AgentCard does not declare capabilities.streaming
    When a client sends a SubscribeToTask request
    Then the server MUST return an UnsupportedOperationError

  # --- Extended Agent Card Capability ---

  Scenario: UnsupportedOperationError when extendedAgentCard is false
    Given a valid A2A server
    And the AgentCard declares capabilities.extendedAgentCard as false
    When a client sends a GetExtendedAgentCard request
    Then the server MUST return an UnsupportedOperationError

  Scenario: UnsupportedOperationError when extendedAgentCard is not present
    Given a valid A2A server
    And the AgentCard does not declare capabilities.extendedAgentCard
    When a client sends a GetExtendedAgentCard request
    Then the server MUST return an UnsupportedOperationError

  Scenario: ExtendedAgentCardNotConfiguredError when declared but not configured
    Given a valid A2A server
    And the AgentCard declares capabilities.extendedAgentCard as true
    But the agent has not configured an extended agent card
    When a client sends a GetExtendedAgentCard request
    Then the server MUST return an ExtendedAgentCardNotConfiguredError

  # --- Extensions Capability ---

  Scenario: ExtensionSupportRequiredError when required extension not declared by client
    Given a valid A2A server
    And the AgentCard lists an extension with required set to true
    When a client sends a request without declaring support for that extension
    Then the server MUST return an ExtensionSupportRequiredError

  Scenario: No error when client declares support for required extension
    Given a valid A2A server
    And the AgentCard lists an extension with required set to true
    When a client sends a request declaring support for that extension in A2A-Extensions
    Then the server MUST NOT return an ExtensionSupportRequiredError

  # --- Client Responsibilities ---

  Scenario: Client should validate capabilities before attempting operations
    Given a valid A2A server
    And the AgentCard is available to the client
    Then the client SHOULD examine the AgentCard capabilities before attempting optional operations
