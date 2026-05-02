Feature: In-Task Authorization - Client and Security (Sections 7.6.2, 7.6.3)
  Client responsibilities and security considerations for in-task authorization.

  # --- Client Responsibilities (7.6.2) ---

  Scenario: Client agent should follow agent responsibilities when delegating auth
    Given an A2A client that is itself an A2A agent processing a Task
    And it receives TASK_STATE_AUTH_REQUIRED from a downstream agent
    When the client delegates the authorization request to its own client
    Then the client SHOULD transition its own Task to TASK_STATE_AUTH_REQUIRED
    And the client SHOULD follow all In-Task Authorization Agent Responsibilities

  Scenario: Client should subscribe to task events to avoid missing updates
    Given a valid A2A client
    And a task has transitioned to TASK_STATE_AUTH_REQUIRED
    And the client does not have an active response stream
    When the credential may be provided out-of-band
    Then the client SHOULD subscribe to task events using SubscribeToTask
    Or register a webhook using CreatePushNotificationConfig
    Or begin polling using GetTask

  # --- Security Considerations (7.6.3) ---

  Scenario: Agent should receive credentials out-of-band via secure channel
    Given a valid A2A server
    When the agent requires credentials for in-task authorization
    Then the agent SHOULD receive credentials via a secure channel such as HTTPS

  Scenario: In-band credentials should be bound to the requesting agent
    Given a chain of A2A agents exchanging credentials in-band
    When credentials are passed through the chain
    Then credentials SHOULD be bound to the agent which originated the request
    And only the originating agent should be able to use the credentials

  Scenario: Sensitive in-band credentials should be encrypted
    Given a chain of A2A agents exchanging credentials in-band
    When credentials contain sensitive information
    Then the credentials SHOULD be only readable by the agent which originated the request
    And the credentials SHOULD be encrypted
