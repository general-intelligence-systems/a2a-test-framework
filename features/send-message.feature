Feature: Send Message Operation (Section 3.1.1)
  The primary operation for initiating agent interactions.
  Clients send a message to an agent and receive either a Task or a direct Message response.

  # --- Response Type Behavior ---

  Scenario: Agent returns a Task object in response to a message
    Given a valid A2A server
    When a client sends a SendMessageRequest with a valid message
    Then the server MAY respond with a Task object
    And the Task object MUST contain a valid task ID
    And the Task object MUST contain a status

  Scenario: Agent returns a direct Message response for simple interactions
    Given a valid A2A server
    When a client sends a SendMessageRequest with a simple message
    Then the server MAY respond with a Message object
    And the Message object MUST contain a role
    And the Message object MUST contain one or more Parts

  Scenario: Operation returns immediately with a Task
    Given a valid A2A server
    When a client sends a SendMessageRequest
    And the server creates a Task to process the message
    Then the response MUST be returned immediately
    And the response MUST contain either a Task or a Message

  Scenario: Task processing continues asynchronously after response
    Given a valid A2A server
    When a client sends a SendMessageRequest
    And the server responds with a Task object
    Then the task processing MAY continue asynchronously after the response is returned
    And the task status MAY be in a non-terminal state

  # --- Error Cases ---

  Scenario: ContentTypeNotSupportedError when media type is unsupported
    Given a valid A2A server
    When a client sends a SendMessageRequest with a Part containing an unsupported media type
    Then the server MUST respond with a ContentTypeNotSupportedError

  Scenario: UnsupportedOperationError when sending message to a completed task
    Given a valid A2A server
    And a task exists with status "completed"
    When a client sends a SendMessageRequest referencing that task's ID
    Then the server MUST respond with an UnsupportedOperationError

  Scenario: UnsupportedOperationError when sending message to a canceled task
    Given a valid A2A server
    And a task exists with status "canceled"
    When a client sends a SendMessageRequest referencing that task's ID
    Then the server MUST respond with an UnsupportedOperationError

  Scenario: UnsupportedOperationError when sending message to a rejected task
    Given a valid A2A server
    And a task exists with status "rejected"
    When a client sends a SendMessageRequest referencing that task's ID
    Then the server MUST respond with an UnsupportedOperationError

  Scenario: TaskNotFoundError when task ID does not exist
    Given a valid A2A server
    When a client sends a SendMessageRequest referencing a non-existent task ID
    Then the server MUST respond with a TaskNotFoundError

  Scenario: TaskNotFoundError when task ID is not accessible to the client
    Given a valid A2A server
    And a task exists that is not accessible to the authenticated client
    When a client sends a SendMessageRequest referencing that task's ID
    Then the server MUST respond with a TaskNotFoundError

  # --- Response Structure Validation ---

  Scenario: Response is exclusively a Task or a Message, never both
    Given a valid A2A server
    When a client sends a SendMessageRequest
    Then the response MUST contain exactly one of Task or Message
    And the response MUST NOT contain both a Task and a Message simultaneously
