Feature: Subscribe to Task Operation (Section 3.1.6)
  Establishes a streaming connection to receive updates for an existing task.
  Enables real-time monitoring of task progress.

  # --- Stream Initialization ---

  Scenario: First event in stream is a Task object with current state
    Given a valid A2A server that supports streaming
    And a task exists with status "working"
    When a client sends a SubscribeToTask request with that task's ID
    Then the first event in the stream MUST be a Task object
    And the Task object MUST represent the current state of the task at the time of subscription

  Scenario: Initial Task object prevents information loss between GetTask and Subscribe
    Given a valid A2A server that supports streaming
    And a task exists with status "working" and has accumulated status updates
    When a client sends a SubscribeToTask request with that task's ID
    Then the first event MUST be a Task object reflecting the current state
    And the client does not need to call GetTask separately to avoid missing updates

  # --- Stream Content ---

  Scenario: Stream delivers TaskStatusUpdateEvent objects
    Given a valid A2A server that supports streaming
    And a task exists with status "working"
    When a client subscribes to the task
    And the task status changes
    Then the stream MUST deliver a TaskStatusUpdateEvent object

  Scenario: Stream delivers TaskArtifactUpdateEvent objects
    Given a valid A2A server that supports streaming
    And a task exists with status "working"
    When a client subscribes to the task
    And the task generates a new artifact
    Then the stream MUST deliver a TaskArtifactUpdateEvent object

  # --- Stream Termination ---

  Scenario: Stream terminates when task reaches completed state
    Given a valid A2A server that supports streaming
    And a client is subscribed to a task
    When the task reaches "completed" state
    Then the stream MUST terminate

  Scenario: Stream terminates when task reaches failed state
    Given a valid A2A server that supports streaming
    And a client is subscribed to a task
    When the task reaches "failed" state
    Then the stream MUST terminate

  Scenario: Stream terminates when task reaches canceled state
    Given a valid A2A server that supports streaming
    And a client is subscribed to a task
    When the task reaches "canceled" state
    Then the stream MUST terminate

  Scenario: Stream terminates when task reaches rejected state
    Given a valid A2A server that supports streaming
    And a client is subscribed to a task
    When the task reaches "rejected" state
    Then the stream MUST terminate

  Scenario: Stream does not terminate while task is in non-terminal state
    Given a valid A2A server that supports streaming
    And a client is subscribed to a task with status "working"
    Then the stream MUST remain open while the task is in a non-terminal state

  # --- Error Cases ---

  Scenario: UnsupportedOperationError when streaming not supported
    Given a valid A2A server that does NOT support streaming
    When a client sends a SubscribeToTask request
    Then the server MUST respond with an UnsupportedOperationError

  Scenario: TaskNotFoundError when task ID does not exist
    Given a valid A2A server that supports streaming
    When a client sends a SubscribeToTask request with a non-existent task ID
    Then the server MUST respond with a TaskNotFoundError

  Scenario: TaskNotFoundError when task ID is not accessible
    Given a valid A2A server that supports streaming
    And a task exists that is not accessible to the authenticated client
    When a client sends a SubscribeToTask request with that task's ID
    Then the server MUST respond with a TaskNotFoundError

  Scenario: UnsupportedOperationError when task is in completed state
    Given a valid A2A server that supports streaming
    And a task exists with status "completed"
    When a client sends a SubscribeToTask request with that task's ID
    Then the server MUST respond with an UnsupportedOperationError

  Scenario: UnsupportedOperationError when task is in failed state
    Given a valid A2A server that supports streaming
    And a task exists with status "failed"
    When a client sends a SubscribeToTask request with that task's ID
    Then the server MUST respond with an UnsupportedOperationError

  Scenario: UnsupportedOperationError when task is in canceled state
    Given a valid A2A server that supports streaming
    And a task exists with status "canceled"
    When a client sends a SubscribeToTask request with that task's ID
    Then the server MUST respond with an UnsupportedOperationError

  Scenario: UnsupportedOperationError when task is in rejected state
    Given a valid A2A server that supports streaming
    And a task exists with status "rejected"
    When a client sends a SubscribeToTask request with that task's ID
    Then the server MUST respond with an UnsupportedOperationError
