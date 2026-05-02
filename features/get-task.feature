Feature: Get Task Operation (Section 3.1.3)
  Retrieves the current state (including status, artifacts, and optionally history)
  of a previously initiated task.

  # --- Successful Retrieval ---

  Scenario: Successfully retrieve an existing task
    Given a valid A2A server
    And a task has been previously created
    When a client sends a GetTask request with the task's ID
    Then the server MUST respond with a Task object
    And the Task object MUST include the current status
    And the Task object MUST include any generated artifacts

  Scenario: Retrieved task includes status information
    Given a valid A2A server
    And a task exists with status "working"
    When a client sends a GetTask request with that task's ID
    Then the response Task object MUST contain a status field
    And the status MUST reflect the current state of the task

  Scenario: Retrieved task includes artifacts
    Given a valid A2A server
    And a task exists that has generated artifacts
    When a client sends a GetTask request with that task's ID
    Then the response Task object MUST include the artifacts field

  Scenario: Get task after polling for completion
    Given a valid A2A server
    And a task was initiated via Send Message
    And the task has since reached "completed" state
    When a client sends a GetTask request with that task's ID
    Then the server MUST respond with a Task object
    And the Task status MUST be "completed"

  Scenario: Get task after push notification received
    Given a valid A2A server
    And a task was initiated via Send Message
    And a push notification was received indicating task completion
    When a client sends a GetTask request with that task's ID
    Then the server MUST respond with a Task object reflecting the final state

  Scenario: Get task after stream has ended
    Given a valid A2A server that supports streaming
    And a task was initiated via Send Streaming Message
    And the stream has closed
    When a client sends a GetTask request with that task's ID
    Then the server MUST respond with a Task object reflecting the final state

  # --- History Length Parameter ---

  Scenario: Get task with history included
    Given a valid A2A server
    And a task exists with message history
    When a client sends a GetTask request with historyLength set to a positive number
    Then the response Task object MUST include up to that many recent messages in the history field

  Scenario: Get task with historyLength set to zero
    Given a valid A2A server
    And a task exists with message history
    When a client sends a GetTask request with historyLength set to 0
    Then the response Task object SHOULD omit the history field

  Scenario: Get task with historyLength unset
    Given a valid A2A server
    And a task exists with message history
    When a client sends a GetTask request without specifying historyLength
    Then the server returns its default amount of history

  # --- Error Cases ---

  Scenario: TaskNotFoundError when task ID does not exist
    Given a valid A2A server
    When a client sends a GetTask request with a non-existent task ID
    Then the server MUST respond with a TaskNotFoundError

  Scenario: TaskNotFoundError when task ID is not accessible to the client
    Given a valid A2A server
    And a task exists that is not accessible to the authenticated client
    When a client sends a GetTask request with that task's ID
    Then the server MUST respond with a TaskNotFoundError
