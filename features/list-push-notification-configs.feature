Feature: List Push Notification Configs Operation (Section 3.1.9)
  Retrieves all push notification configurations for a task.

  # --- Successful Retrieval ---

  Scenario: Returns all active push notification configs for a task
    Given a valid A2A server that supports push notifications
    And a task exists with multiple push notification configs
    When a client sends a ListPushNotificationConfigs request with the task's ID
    Then the response MUST contain all active push notification configurations for that task

  Scenario: Returns empty list when no configs exist for a task
    Given a valid A2A server that supports push notifications
    And a task exists with no push notification configs
    When a client sends a ListPushNotificationConfigs request with the task's ID
    Then the response MUST contain an empty list of configurations

  Scenario: Only active configurations are returned
    Given a valid A2A server that supports push notifications
    And a task exists with some active and some deleted push notification configs
    When a client sends a ListPushNotificationConfigs request with the task's ID
    Then the response MUST only contain active configurations
    And deleted configurations MUST NOT appear in the response

  # --- Pagination ---

  Scenario: Pagination supported for tasks with many configurations
    Given a valid A2A server that supports push notifications
    And a task exists with many push notification configs
    When a client sends a ListPushNotificationConfigs request
    Then the server MAY support pagination for the results

  # --- Error Cases ---

  Scenario: PushNotificationNotSupportedError when agent does not support push notifications
    Given a valid A2A server that does NOT support push notifications
    When a client sends a ListPushNotificationConfigs request
    Then the server MUST respond with a PushNotificationNotSupportedError

  Scenario: TaskNotFoundError when task ID does not exist
    Given a valid A2A server that supports push notifications
    When a client sends a ListPushNotificationConfigs request with a non-existent task ID
    Then the server MUST respond with a TaskNotFoundError

  Scenario: TaskNotFoundError when task ID is not accessible to the client
    Given a valid A2A server that supports push notifications
    And a task exists that is not accessible to the authenticated client
    When a client sends a ListPushNotificationConfigs request with that task's ID
    Then the server MUST respond with a TaskNotFoundError
