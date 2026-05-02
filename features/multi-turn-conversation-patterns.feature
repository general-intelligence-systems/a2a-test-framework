Feature: Multi-Turn Conversation Patterns (Section 3.4.3)
  The A2A protocol supports several patterns for multi-turn interactions.

  # --- Context Continuity ---

  Scenario: Client uses contextId to indicate continuation of previous interaction
    Given a valid A2A server
    And a task was previously created with contextId "ctx-123"
    When a client sends a new Message with contextId "ctx-123"
    Then the agent SHOULD treat this as a continuation of the previous interaction

  Scenario: Client uses taskId to continue a specific task
    Given a valid A2A server
    And a task exists with taskId "task-456"
    When a client sends a Message with taskId "task-456"
    Then the agent MUST treat this as continuing or refining that specific task

  Scenario: Client uses contextId without taskId to start new task in existing context
    Given a valid A2A server
    And a context "ctx-123" has been established with a previous task
    When a client sends a Message with contextId "ctx-123" but no taskId
    Then the agent MAY create a new task within that existing context

  Scenario: Agent must infer contextId from task when only taskId is provided
    Given a valid A2A server
    And a task exists with taskId "task-456" and contextId "ctx-789"
    When a client sends a Message with only taskId "task-456" and no contextId
    Then the agent MUST infer the contextId from the referenced task
    And the effective contextId MUST be "ctx-789"

  Scenario: Agent must reject message with mismatching contextId and taskId
    Given a valid A2A server
    And a task exists with taskId "task-456" and contextId "ctx-789"
    When a client sends a Message with taskId "task-456" and contextId "ctx-different"
    Then the agent MUST reject the message with an error
    Because the provided contextId is different from the task's contextId

  Scenario: Agent accepts message with matching contextId and taskId
    Given a valid A2A server
    And a task exists with taskId "task-456" and contextId "ctx-789"
    When a client sends a Message with taskId "task-456" and contextId "ctx-789"
    Then the agent MUST accept the message

  # --- Input Required State ---

  Scenario: Agent transitions task to input-required to request additional input
    Given a valid A2A server
    And a task exists with status "working"
    When the agent needs additional input from the client
    Then the agent transitions the task to "input_required" state

  Scenario: Client continues interaction by sending message with same taskId after input-required
    Given a valid A2A server
    And a task exists with status "input_required" with taskId "task-456" and contextId "ctx-789"
    When the client sends a new Message with taskId "task-456" and contextId "ctx-789"
    Then the agent MUST accept the message and continue processing the task

  # --- Follow-up Messages ---

  Scenario: Client sends follow-up message with taskId to refine existing task
    Given a valid A2A server
    And a task exists with taskId "task-456" in a non-terminal state
    When a client sends a follow-up Message with taskId "task-456"
    Then the agent MUST accept the message as a refinement of the existing task

  Scenario: Client uses referenceTaskIds to explicitly reference related tasks
    Given a valid A2A server
    And tasks exist with taskIds "task-1" and "task-2"
    When a client sends a new Message with referenceTaskIds set to ["task-1", "task-2"]
    Then the agent SHOULD use the referenced tasks to understand context and intent

  # --- Context Inheritance ---

  Scenario: New task in same context can inherit context from previous interactions
    Given a valid A2A server
    And a task was previously completed with contextId "ctx-123" and produced results
    When a client sends a new Message with contextId "ctx-123" without taskId
    Then the agent SHOULD leverage the shared contextId to provide contextually relevant responses
