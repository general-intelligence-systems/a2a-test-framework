Feature: Operation Idempotency (Section 3.3.1)
  Defines idempotency guarantees for different A2A operations.

  # --- Get Operations are Naturally Idempotent ---

  Scenario: GetTask is idempotent - repeated calls return same result
    Given a valid A2A server
    And a task exists with status "completed"
    When a client sends a GetTask request for that task
    And the client sends the same GetTask request again
    Then both responses MUST return the same Task state

  Scenario: ListTasks is idempotent - repeated calls return same result
    Given a valid A2A server
    And tasks exist for the authenticated client
    When a client sends a ListTasks request
    And the client sends the same ListTasks request again
    Then both responses MUST return the same list of tasks (assuming no state changes)

  Scenario: GetExtendedAgentCard is idempotent - repeated calls return same result
    Given a valid A2A server with extendedAgentCard capability enabled
    And the client is properly authenticated
    When a client sends a GetExtendedAgentCard request
    And the client sends the same GetExtendedAgentCard request again
    Then both responses MUST return the same AgentCard

  # --- Send Message Idempotency ---

  Scenario: SendMessage MAY be idempotent using messageId for deduplication
    Given a valid A2A server
    When a client sends a SendMessageRequest with a specific messageId
    And the client sends the same SendMessageRequest with the same messageId again
    Then the agent MAY detect the duplicate using messageId
    And the agent MAY return the same result without reprocessing

  Scenario: SendMessage with same messageId may be treated as duplicate
    Given a valid A2A server that implements messageId deduplication
    When a client sends a SendMessageRequest with messageId "msg-123"
    And the server processes the message and returns a Task
    And the client sends another SendMessageRequest with the same messageId "msg-123"
    Then the server MAY return the previously created Task without reprocessing

  # --- Cancel Task Idempotency ---

  Scenario: CancelTask is idempotent - multiple cancellations have same effect
    Given a valid A2A server
    And a task exists in a cancelable state
    When a client sends a CancelTask request for that task
    And the task is successfully canceled
    And the client sends another CancelTask request for the same task
    Then the multiple cancellation requests MUST have the same effect

  Scenario: Duplicate CancelTask may return TaskNotFoundError if task is purged
    Given a valid A2A server
    And a task was previously canceled and then purged by the server
    When a client sends a CancelTask request for that purged task
    Then the server MAY return a TaskNotFoundError
