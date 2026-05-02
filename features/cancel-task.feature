Feature: Cancel Task Operation (Section 3.1.5)
  Requests the cancellation of an ongoing task.
  The server will attempt to cancel the task, but success is not guaranteed.

  # --- Successful Cancellation ---

  Scenario: Successfully cancel a working task
    Given a valid A2A server
    And a task exists with status "working"
    When a client sends a CancelTask request with that task's ID
    Then the server MUST respond with an updated Task object
    And the Task status MUST reflect the cancellation

  Scenario: Cancel task returns updated task state
    Given a valid A2A server
    And a task exists in a cancelable state
    When a client sends a CancelTask request with that task's ID
    Then the response MUST be an updated Task object with cancellation status

  Scenario: Cancel task that is in input_required state
    Given a valid A2A server
    And a task exists with status "input_required"
    When a client sends a CancelTask request with that task's ID
    Then the server MUST respond with an updated Task object
    And the Task status MUST reflect the cancellation

  # --- Error Cases ---

  Scenario: TaskNotCancelableError when task is already completed
    Given a valid A2A server
    And a task exists with status "completed"
    When a client sends a CancelTask request with that task's ID
    Then the server MUST respond with a TaskNotCancelableError

  Scenario: TaskNotCancelableError when task is already failed
    Given a valid A2A server
    And a task exists with status "failed"
    When a client sends a CancelTask request with that task's ID
    Then the server MUST respond with a TaskNotCancelableError

  Scenario: TaskNotCancelableError when task is already canceled
    Given a valid A2A server
    And a task exists with status "canceled"
    When a client sends a CancelTask request with that task's ID
    Then the server MUST respond with a TaskNotCancelableError

  Scenario: TaskNotFoundError when task ID does not exist
    Given a valid A2A server
    When a client sends a CancelTask request with a non-existent task ID
    Then the server MUST respond with a TaskNotFoundError

  Scenario: TaskNotFoundError when task ID is not accessible to the client
    Given a valid A2A server
    And a task exists that is not accessible to the authenticated client
    When a client sends a CancelTask request with that task's ID
    Then the server MUST respond with a TaskNotFoundError

  # --- Idempotency (from Section 3.3.1) ---

  Scenario: Multiple cancellation requests are idempotent
    Given a valid A2A server
    And a task exists in a cancelable state
    When a client sends a CancelTask request with that task's ID
    And the task is successfully canceled
    And the client sends another CancelTask request with the same task's ID
    Then the server MAY respond with a TaskNotCancelableError
    Or the server MAY respond with a TaskNotFoundError if the task has been purged
