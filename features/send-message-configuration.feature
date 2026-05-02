Feature: SendMessageConfiguration - Execution Mode (Section 3.2.2)
  The return_immediately field controls whether the operation returns
  immediately or waits for task completion. Operations are blocking by default.

  # --- Blocking Mode (Default) ---

  Scenario: Blocking mode waits until task reaches completed state
    Given a valid A2A server
    When a client sends a SendMessageRequest with return_immediately unset
    And the server creates a Task
    Then the operation MUST wait until the task reaches "completed" state before returning
    And the response MUST include the latest task state with all artifacts and status information

  Scenario: Blocking mode waits until task reaches failed state
    Given a valid A2A server
    When a client sends a SendMessageRequest with return_immediately set to false
    And the server creates a Task that will fail
    Then the operation MUST wait until the task reaches "failed" state before returning
    And the response MUST include the latest task state

  Scenario: Blocking mode waits until task reaches canceled state
    Given a valid A2A server
    When a client sends a SendMessageRequest with return_immediately unset
    And the server creates a Task that gets canceled
    Then the operation MUST wait until the task reaches "canceled" state before returning

  Scenario: Blocking mode waits until task reaches rejected state
    Given a valid A2A server
    When a client sends a SendMessageRequest with return_immediately unset
    And the server creates a Task that gets rejected
    Then the operation MUST wait until the task reaches "rejected" state before returning

  Scenario: Blocking mode waits until task reaches input_required state
    Given a valid A2A server
    When a client sends a SendMessageRequest with return_immediately unset
    And the server creates a Task that requires input
    Then the operation MUST wait until the task reaches "input_required" state before returning
    And the response MUST include the latest task state

  Scenario: Blocking mode waits until task reaches auth_required state
    Given a valid A2A server
    When a client sends a SendMessageRequest with return_immediately unset
    And the server creates a Task that requires authentication
    Then the operation MUST wait until the task reaches "auth_required" state before returning
    And the response MUST include the latest task state

  Scenario: Blocking mode response includes all artifacts
    Given a valid A2A server
    When a client sends a SendMessageRequest in blocking mode
    And the task completes with artifacts
    Then the response MUST include the latest task state with all artifacts

  Scenario: Blocking mode is the default when return_immediately is not set
    Given a valid A2A server
    When a client sends a SendMessageRequest without specifying return_immediately
    Then the operation MUST behave in blocking mode by default

  # --- Non-Blocking Mode ---

  Scenario: Non-blocking mode returns immediately after task creation
    Given a valid A2A server
    When a client sends a SendMessageRequest with return_immediately set to true
    And the server creates a Task
    Then the operation MUST return immediately after creating the task
    And the response MUST NOT wait for the task to reach a terminal state

  Scenario: Non-blocking mode returns task in in-progress state
    Given a valid A2A server
    When a client sends a SendMessageRequest with return_immediately set to true
    Then the returned task MUST have an in-progress state
    And the task status MAY be "working" or another non-terminal state

  Scenario: Non-blocking mode requires client to poll for updates
    Given a valid A2A server
    When a client sends a SendMessageRequest with return_immediately set to true
    And receives a task in an in-progress state
    Then it is the caller's responsibility to poll for updates using GetTask
    Or subscribe via SubscribeToTask
    Or receive updates via push notifications

  # --- No Effect Cases ---

  Scenario: return_immediately has no effect when response is a direct Message
    Given a valid A2A server
    When a client sends a SendMessageRequest with return_immediately set to true
    And the agent returns a direct Message response instead of a Task
    Then the return_immediately field MUST have no effect on the response behavior

  Scenario: return_immediately has no effect on streaming operations
    Given a valid A2A server that supports streaming
    When a client sends a SendStreamingMessage request with return_immediately set to true
    Then the return_immediately field MUST have no effect
    And the streaming operation MUST always return updates in real-time

  Scenario: return_immediately has no effect on push notification configurations
    Given a valid A2A server that supports push notifications
    And a push notification config is set up for a task
    When a client sends a SendMessageRequest with return_immediately set to false
    Then push notification delivery MUST operate independently of the execution mode
