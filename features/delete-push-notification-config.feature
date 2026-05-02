Feature: Delete Push Notification Config Operation (Section 3.1.10)
  Removes a push notification configuration for a task.

  # --- Successful Deletion ---

  Scenario: Successfully delete a push notification config
    Given a valid A2A server that supports push notifications
    And a push notification config exists for a task
    When a client sends a DeletePushNotificationConfig request with the config's ID and task ID
    Then the server MUST respond with a confirmation of deletion

  Scenario: Deleted config is permanently removed
    Given a valid A2A server that supports push notifications
    And a push notification config exists for a task
    When a client deletes that push notification config
    Then the configuration MUST be permanently removed
    And a subsequent GetPushNotificationConfig request for that config MUST fail

  Scenario: No further notifications sent after deletion
    Given a valid A2A server that supports push notifications
    And a push notification config exists for a task
    When a client deletes that push notification config
    And the task subsequently changes status
    Then no notifications MUST be sent to the previously configured webhook URL

  # --- Idempotency ---

  Scenario: Multiple deletions of the same config are idempotent
    Given a valid A2A server that supports push notifications
    And a push notification config exists for a task
    When a client sends a DeletePushNotificationConfig request for that config
    And the client sends another DeletePushNotificationConfig request for the same config
    Then both requests MUST have the same effect
    And the second request MUST NOT return an error

  Scenario: Deleting an already-deleted config does not fail
    Given a valid A2A server that supports push notifications
    And a push notification config was previously deleted
    When a client sends a DeletePushNotificationConfig request for the same config
    Then the server MUST NOT return an error

  # --- Error Cases ---

  Scenario: PushNotificationNotSupportedError when agent does not support push notifications
    Given a valid A2A server that does NOT support push notifications
    When a client sends a DeletePushNotificationConfig request
    Then the server MUST respond with a PushNotificationNotSupportedError

  Scenario: TaskNotFoundError when task ID does not exist
    Given a valid A2A server that supports push notifications
    When a client sends a DeletePushNotificationConfig request with a non-existent task ID
    Then the server MUST respond with a TaskNotFoundError
