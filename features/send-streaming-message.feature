Feature: Send Streaming Message Operation (Section 3.1.2)
  Similar to Send Message but with real-time streaming of updates during processing.
  The operation establishes a streaming connection for real-time updates.

  # --- Streaming Connection Establishment ---

  Scenario: Operation establishes a streaming connection
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request with a valid message
    Then the server MUST establish a streaming connection for real-time updates

  # --- Message-Only Stream Pattern ---

  Scenario: Message-only stream contains exactly one Message then closes
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request
    And the agent returns a Message response
    Then the stream MUST contain exactly one Message object
    And the stream MUST close immediately after the Message

  Scenario: Message-only stream provides no task tracking or updates
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request
    And the agent returns a Message response
    Then the stream MUST NOT contain any TaskStatusUpdateEvent objects
    And the stream MUST NOT contain any TaskArtifactUpdateEvent objects
    And the stream MUST NOT contain any Task objects

  # --- Task Lifecycle Stream Pattern ---

  Scenario: Task lifecycle stream begins with Task object
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request
    And the agent returns a Task response
    Then the first item in the stream MUST be a Task object

  Scenario: Task lifecycle stream followed by status and artifact events
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request
    And the agent returns a Task response
    Then the stream MAY contain TaskStatusUpdateEvent objects after the Task
    And the stream MAY contain TaskArtifactUpdateEvent objects after the Task

  Scenario: Task lifecycle stream closes when task reaches completed state
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request
    And the agent returns a Task response
    And the task reaches "completed" state
    Then the stream MUST close

  Scenario: Task lifecycle stream closes when task reaches failed state
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request
    And the agent returns a Task response
    And the task reaches "failed" state
    Then the stream MUST close

  Scenario: Task lifecycle stream closes when task reaches canceled state
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request
    And the agent returns a Task response
    And the task reaches "canceled" state
    Then the stream MUST close

  Scenario: Task lifecycle stream closes when task reaches rejected state
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request
    And the agent returns a Task response
    And the task reaches "rejected" state
    Then the stream MUST close

  Scenario: Task lifecycle stream does not close before terminal state
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request
    And the agent returns a Task response
    And the task is in "working" state
    Then the stream MUST NOT close

  # --- Immediate Feedback Requirement ---

  Scenario: Implementation provides immediate feedback on progress
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request
    Then the server MUST provide immediate feedback on progress
    And intermediate results MUST be delivered as they become available

  # --- Error Cases ---

  Scenario: UnsupportedOperationError when streaming not supported
    Given a valid A2A server that does NOT support streaming
    When a client sends a SendStreamingMessage request
    Then the server MUST respond with an UnsupportedOperationError

  Scenario: UnsupportedOperationError when sending to a completed task
    Given a valid A2A server that supports streaming
    And a task exists with status "completed"
    When a client sends a SendStreamingMessage request referencing that task's ID
    Then the server MUST respond with an UnsupportedOperationError

  Scenario: UnsupportedOperationError when sending to a canceled task
    Given a valid A2A server that supports streaming
    And a task exists with status "canceled"
    When a client sends a SendStreamingMessage request referencing that task's ID
    Then the server MUST respond with an UnsupportedOperationError

  Scenario: UnsupportedOperationError when sending to a rejected task
    Given a valid A2A server that supports streaming
    And a task exists with status "rejected"
    When a client sends a SendStreamingMessage request referencing that task's ID
    Then the server MUST respond with an UnsupportedOperationError

  Scenario: ContentTypeNotSupportedError when media type is unsupported
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request with a Part containing an unsupported media type
    Then the server MUST respond with a ContentTypeNotSupportedError

  Scenario: TaskNotFoundError when task ID does not exist
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request referencing a non-existent task ID
    Then the server MUST respond with a TaskNotFoundError

  Scenario: TaskNotFoundError when task ID is not accessible
    Given a valid A2A server that supports streaming
    And a task exists that is not accessible to the authenticated client
    When a client sends a SendStreamingMessage request referencing that task's ID
    Then the server MUST respond with a TaskNotFoundError

  # --- Stream Response Structure ---

  Scenario: Stream initial response is exclusively Task or Message
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request
    Then the initial stream response MUST be exactly one of Task or Message
    And the initial stream response MUST NOT contain both
