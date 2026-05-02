Feature: History Length Semantics (Section 3.2.4)
  The historyLength parameter controls how much task history is returned
  in responses. It follows consistent semantics across all operations.

  # --- Unset/Undefined ---

  Scenario: historyLength unset returns server default amount of history
    Given a valid A2A server
    And a task exists with message history
    When a client sends a request without specifying historyLength
    Then the server returns its default amount of history
    And the default amount is implementation-defined

  # --- Zero Value ---

  Scenario: historyLength set to 0 omits history field
    Given a valid A2A server
    And a task exists with message history
    When a client sends a request with historyLength set to 0
    Then the response SHOULD omit the history field entirely

  Scenario: historyLength set to 0 returns no messages
    Given a valid A2A server
    And a task exists with 10 messages in history
    When a client sends a request with historyLength set to 0
    Then no history messages SHOULD be included in the response

  # --- Positive Value ---

  Scenario: historyLength set to positive number limits returned messages
    Given a valid A2A server
    And a task exists with 10 messages in history
    When a client sends a request with historyLength set to 3
    Then the response MUST return at most 3 recent messages from the task's history

  Scenario: historyLength returns most recent messages
    Given a valid A2A server
    And a task exists with 10 messages in history
    When a client sends a request with historyLength set to 5
    Then the returned messages MUST be the 5 most recent messages

  Scenario: historyLength greater than total messages returns all messages
    Given a valid A2A server
    And a task exists with 3 messages in history
    When a client sends a request with historyLength set to 100
    Then the response MUST return all 3 messages from the task's history

  # --- Consistency Across Operations ---

  Scenario: historyLength semantics are consistent in GetTask
    Given a valid A2A server
    And a task exists with message history
    When a client sends a GetTask request with historyLength set to 2
    Then the response MUST return at most 2 recent messages

  Scenario: historyLength semantics are consistent in SendMessage response
    Given a valid A2A server
    When a client sends a SendMessageRequest with historyLength set to 2
    And the response is a Task object
    Then the Task MUST return at most 2 recent messages in history
