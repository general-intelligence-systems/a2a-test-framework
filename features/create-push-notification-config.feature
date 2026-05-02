Feature: Create Push Notification Config Operation (Section 3.1.7)
  Creates a push notification configuration for a task to receive
  asynchronous updates via webhook.

  # --- Successful Creation ---

  Scenario: Successfully create a push notification config for a task
    Given a valid A2A server that supports push notifications
    And a task exists in a non-terminal state
    When a client sends a CreatePushNotificationConfig request with a valid webhook URL and the task's ID
    Then the server MUST respond with a PushNotificationConfig object
    And the PushNotificationConfig MUST contain an assigned ID

  Scenario: Webhook endpoint is established for task update notifications
    Given a valid A2A server that supports push notifications
    And a task exists in a non-terminal state
    When a client creates a push notification config with a webhook URL
    Then the server MUST establish a webhook endpoint for task update notifications
    And when task updates occur the agent MUST send HTTP POST requests to the configured webhook URL

  Scenario: Webhook payload uses StreamResponse format
    Given a valid A2A server that supports push notifications
    And a push notification config has been created for a task
    When the task status changes
    Then the agent MUST send an HTTP POST request to the configured webhook URL
    And the payload MUST be a StreamResponse object

  # --- Configuration Persistence ---

  Scenario: Configuration persists until task completion
    Given a valid A2A server that supports push notifications
    And a push notification config has been created for a task
    When the task is still in a non-terminal state
    Then the push notification configuration MUST still be active

  Scenario: Configuration persists until explicit deletion
    Given a valid A2A server that supports push notifications
    And a push notification config has been created for a task
    When the config has not been explicitly deleted
    And the task is still in a non-terminal state
    Then the push notification configuration MUST still be active

  Scenario: Configuration ceases after task completion
    Given a valid A2A server that supports push notifications
    And a push notification config has been created for a task
    When the task reaches "completed" state
    Then the push notification configuration need not persist beyond this point

  # --- Error Cases ---

  Scenario: PushNotificationNotSupportedError when agent does not support push notifications
    Given a valid A2A server that does NOT support push notifications
    When a client sends a CreatePushNotificationConfig request
    Then the server MUST respond with a PushNotificationNotSupportedError

  Scenario: TaskNotFoundError when task ID does not exist
    Given a valid A2A server that supports push notifications
    When a client sends a CreatePushNotificationConfig request with a non-existent task ID
    Then the server MUST respond with a TaskNotFoundError

  Scenario: TaskNotFoundError when task ID is not accessible to the client
    Given a valid A2A server that supports push notifications
    And a task exists that is not accessible to the authenticated client
    When a client sends a CreatePushNotificationConfig request with that task's ID
    Then the server MUST respond with a TaskNotFoundError

  # --- Capability Validation ---

  Scenario: Operation only available when pushNotifications capability is true
    Given a valid A2A server
    And the AgentCard declares capabilities.pushNotifications as true
    When a client sends a CreatePushNotificationConfig request
    Then the server MUST accept the request and process it

  Scenario: Operation unavailable when pushNotifications capability is false
    Given a valid A2A server
    And the AgentCard declares capabilities.pushNotifications as false
    When a client sends a CreatePushNotificationConfig request
    Then the server MUST respond with a PushNotificationNotSupportedError
