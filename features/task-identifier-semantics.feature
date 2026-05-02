Feature: Task Identifier Semantics (Section 3.4.2)
  A taskId is a unique identifier for a Task object, representing a
  stateful unit of work with a defined lifecycle.

  # --- Server Generation ---

  Scenario: Task IDs are server-generated
    Given a valid A2A server
    When a client sends a Message that triggers task creation
    Then the server MUST generate the taskId
    And the client does not provide the taskId for new task creation

  Scenario: Agent must generate a unique taskId for each new task
    Given a valid A2A server
    When a client sends a Message that creates a task
    And the client sends another Message that creates a different task
    Then each task MUST have a unique taskId
    And the two taskIds MUST be different

  Scenario: Generated taskId must be included in the Task response
    Given a valid A2A server
    When a client sends a Message that triggers task creation
    And the response is a Task object
    Then the Task object MUST include the generated taskId

  # --- Client-Provided taskId References ---

  Scenario: Client-provided taskId must reference an existing task
    Given a valid A2A server
    And a task exists with taskId "task-existing-123"
    When a client sends a Message with taskId "task-existing-123"
    Then the server MUST treat this as a reference to the existing task

  Scenario: TaskNotFoundError when client-provided taskId does not exist
    Given a valid A2A server
    When a client sends a Message with a taskId that does not correspond to an existing task
    Then the server MUST return a TaskNotFoundError

  Scenario: Client-provided taskId for creating new tasks is not supported
    Given a valid A2A server
    When a client sends a Message with a taskId intended to create a new task with that ID
    Then the server MUST NOT create a new task with the client-provided taskId
    And the server MUST return a TaskNotFoundError since the task does not exist
