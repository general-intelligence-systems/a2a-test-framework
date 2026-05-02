Feature: Messages and Artifacts (Section 3.7)
  Messages and Artifacts serve distinct purposes. Messages are for communication,
  Artifacts are for task outputs.

  # --- Message/Artifact Separation ---

  Scenario: Messages should not be used to deliver task outputs
    Given a valid A2A server
    When a task produces output results
    Then the results SHOULD be returned using Artifacts associated with the Task
    And Messages SHOULD NOT be used to deliver task outputs

  Scenario: Task outputs are returned as Artifacts
    Given a valid A2A server
    When a task completes and generates output
    Then the output SHOULD be associated with the Task as Artifacts

  # --- Message Reliability ---

  Scenario: Messages must not be considered a reliable delivery mechanism
    Given a valid A2A server that supports streaming
    And a client is subscribed to a task
    When the client disconnects and reconnects
    Then the client MAY not receive all status update messages that were sent during disconnection
    And Messages MUST NOT be considered a reliable delivery mechanism for critical information

  Scenario: Clients must not rely on all messages being persisted in task history
    Given a valid A2A server
    And a task has exchanged multiple messages during execution
    When a client retrieves the task history
    Then the client MUST NOT rely on all Messages being persisted in the Task history
    Unless this behavior was negotiated out-of-band

  # --- Task History Persistence ---

  Scenario: Not all messages are guaranteed to be in task history
    Given a valid A2A server
    And a task has received transient informational messages during execution
    When a client retrieves the task history
    Then transient informational messages MAY not be present in the history

  Scenario: Messages exchanged prior to task creation may not be in history
    Given a valid A2A server
    And messages were exchanged that resulted in a direct Message response before a task was created
    When a task is subsequently created and client retrieves its history
    Then messages exchanged prior to task creation MAY not be stored in Task history

  Scenario: Agent determines which messages are persisted in task history
    Given a valid A2A server
    And a task has exchanged multiple messages
    Then the agent is responsible for determining which Messages are persisted in the Task History
