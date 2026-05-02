Feature: Push Notification Delivery Protocol (Section 3.5.1)
  Regardless of the protocol binding being used by the agent, WebHook calls
  use plain HTTP and the JSON payloads as defined in the HTTP protocol binding.

  Scenario: Push notification webhooks use plain HTTP regardless of agent binding
    Given an A2A server using the gRPC protocol binding
    And a push notification config has been created for a task
    When the task status changes
    Then the webhook call MUST use plain HTTP
    And the webhook payload MUST use JSON format as defined in the HTTP protocol binding

  Scenario: Push notification webhooks from JSON-RPC agent use plain HTTP
    Given an A2A server using the JSON-RPC protocol binding
    And a push notification config has been created for a task
    When the task status changes
    Then the webhook call MUST use plain HTTP
    And the webhook payload MUST use JSON format as defined in the HTTP protocol binding

  Scenario: Push notification webhooks from custom binding agent use plain HTTP
    Given an A2A server using a custom protocol binding
    And a push notification config has been created for a task
    When the task status changes
    Then the webhook call MUST use plain HTTP
    And the webhook payload MUST use JSON format as defined in the HTTP protocol binding

  Scenario: Streaming requires AgentCard.capabilities.streaming to be true
    Given a valid A2A server
    When a client checks the AgentCard for streaming support
    Then streaming operations are only available if capabilities.streaming is true

  Scenario: Push notifications require AgentCard.capabilities.pushNotifications to be true
    Given a valid A2A server
    When a client checks the AgentCard for push notification support
    Then push notification operations are only available if capabilities.pushNotifications is true
