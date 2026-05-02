Feature: Get Push Notification Config Operation (Section 3.1.8)
  Retrieves an existing push notification configuration for a task.

  # --- Successful Retrieval ---

  Scenario: Successfully retrieve an existing push notification config
    Given a valid A2A server that supports push notifications
    And a push notification config exists for a task
    When a client sends a GetPushNotificationConfig request with the config's ID and task ID
    Then the server MUST respond with a PushNotificationConfig object

  Scenario: Returned config includes webhook URL
    Given a valid A2A server that supports push notifications
    And a push notification config exists for a task
    When a client sends a GetPushNotificationConfig request
    Then the response MUST include the webhook URL in the configuration details

  Scenario: Returned config includes notification settings
    Given a valid A2A server that supports push notifications
    And a push notification config exists for a task
    When a client sends a GetPushNotificationConfig request
    Then the response MUST include the notification settings in the configuration details

  # --- Error Cases ---

  Scenario: PushNotificationNotSupportedError when agent does not support push notifications
    Given a valid A2A server that does NOT support push notifications
    When a client sends a GetPushNotificationConfig request
    Then the server MUST respond with a PushNotificationNotSupportedError

  Scenario: Operation fails when configuration does not exist
    Given a valid A2A server that supports push notifications
    When a client sends a GetPushNotificationConfig request with a non-existent config ID
    Then the server MUST fail with a TaskNotFoundError

  Scenario: Operation fails when client lacks access to the configuration
    Given a valid A2A server that supports push notifications
    And a push notification config exists that is not accessible to the authenticated client
    When a client sends a GetPushNotificationConfig request for that config
    Then the server MUST fail with an error
