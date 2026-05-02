Feature: Push Notification Payload (Section 4.3.3)
  When a task update occurs, the agent sends an HTTP POST request to the
  configured webhook URL with a StreamResponse payload.

  # --- Request Format ---

  Scenario: Push notification uses HTTP POST method
    Given a valid A2A server that supports push notifications
    And a push notification config has been created for a task
    When the task status changes
    Then the agent MUST send an HTTP POST request to the configured webhook URL

  Scenario: Push notification Content-Type is application/a2a+json
    Given a valid A2A server that supports push notifications
    And a push notification config has been created for a task
    When the task status changes
    Then the webhook request MUST include Content-Type header set to "application/a2a+json"

  # --- Payload Structure ---

  Scenario: Payload contains exactly one of task, message, statusUpdate, or artifactUpdate
    Given a valid A2A server that supports push notifications
    And a push notification config has been created for a task
    When a push notification is delivered
    Then the payload MUST be a StreamResponse object containing exactly one field
    And the field MUST be one of: task, message, statusUpdate, or artifactUpdate

  Scenario: Payload with task field contains current task state
    Given a valid A2A server that supports push notifications
    When a push notification is delivered with a task field
    Then the task field MUST contain a valid Task object with current task state

  Scenario: Payload with statusUpdate field contains TaskStatusUpdateEvent
    Given a valid A2A server that supports push notifications
    When a push notification is delivered with a statusUpdate field
    Then the statusUpdate field MUST contain a valid TaskStatusUpdateEvent object

  Scenario: Payload with artifactUpdate field contains TaskArtifactUpdateEvent
    Given a valid A2A server that supports push notifications
    When a push notification is delivered with an artifactUpdate field
    Then the artifactUpdate field MUST contain a valid TaskArtifactUpdateEvent object

  # --- Authentication ---

  Scenario: Agent must include authentication credentials in webhook request
    Given a valid A2A server that supports push notifications
    And a push notification config has been created with authentication info
    When the agent sends a webhook notification
    Then the request MUST include authentication credentials in the request headers
    And the credentials MUST match the format specified in PushNotificationConfig.authentication

  Scenario: Bearer token authentication in webhook request
    Given a valid A2A server that supports push notifications
    And a push notification config has been created with Bearer token authentication
    When the agent sends a webhook notification
    Then the request MUST include an Authorization header with "Bearer {token}"

  # --- Client Responsibilities ---

  Scenario: Client must respond with HTTP 2xx to acknowledge receipt
    Given a valid A2A client receiving push notifications
    When the client receives a valid push notification
    Then the client MUST respond with an HTTP 2xx status code

  Scenario: Client should process notifications idempotently
    Given a valid A2A client receiving push notifications
    When the client receives the same notification twice (duplicate delivery)
    Then the client SHOULD process notifications idempotently
    And the duplicate SHOULD NOT cause unintended side effects

  Scenario: Client must validate task ID matches expected task
    Given a valid A2A client receiving push notifications
    When the client receives a push notification
    Then the client MUST validate the task ID matches an expected task

  Scenario: Client should verify notification source
    Given a valid A2A client receiving push notifications
    When the client receives a push notification
    Then the client SHOULD implement appropriate security measures to verify the notification source

  # --- Server Delivery Guarantees ---

  Scenario: Agent must attempt delivery at least once
    Given a valid A2A server that supports push notifications
    And a push notification config has been created for a task
    When the task status changes
    Then the agent MUST attempt delivery at least once for the configured webhook

  Scenario: Agent may implement retry logic with exponential backoff
    Given a valid A2A server that supports push notifications
    And a push notification config has been created for a task
    When a webhook delivery fails (non-2xx response)
    Then the agent MAY implement retry logic with exponential backoff

  Scenario: Agent should include reasonable timeout for webhook requests
    Given a valid A2A server that supports push notifications
    When the agent sends a webhook notification
    Then the agent SHOULD include a reasonable timeout for the request

  Scenario: Agent may stop delivery after consecutive failures
    Given a valid A2A server that supports push notifications
    And a webhook endpoint consistently fails
    When multiple consecutive delivery attempts fail
    Then the agent MAY stop attempting delivery after a configured number of failures
