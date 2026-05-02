Feature: Context Identifier Semantics (Section 3.4.1)
  A contextId logically groups multiple related Task and Message objects,
  providing continuity across a series of interactions.

  # --- Generation and Assignment ---

  Scenario: Agent may generate contextId when message has no contextId
    Given a valid A2A server
    When a client sends a Message without a contextId field
    Then the agent MAY generate a new contextId

  Scenario: Generated contextId must be included in Task response
    Given a valid A2A server
    When a client sends a Message without a contextId
    And the agent generates a new contextId
    And the response is a Task object
    Then the Task MUST include the generated contextId

  Scenario: Generated contextId must be included in Message response
    Given a valid A2A server
    When a client sends a Message without a contextId
    And the agent generates a new contextId
    And the response is a Message object
    Then the Message MUST include the generated contextId

  Scenario: Agent may accept and preserve client-provided contextId
    Given a valid A2A server
    When a client sends a Message with a contextId "ctx-abc-123"
    Then the agent MAY accept and preserve that contextId in the response

  Scenario: Agent must reject request if it cannot accept client-provided contextId
    Given a valid A2A server that does not accept client-provided contextIds
    When a client sends a Message with a contextId "ctx-client-gen"
    Then the agent MUST reject the request with an error

  Scenario: Agent must not generate new contextId when rejecting client-provided contextId
    Given a valid A2A server that does not accept client-provided contextIds
    When a client sends a Message with a contextId "ctx-client-gen"
    Then the agent MUST NOT generate a new contextId for the response
    And the response MUST be an error

  # --- Grouping and Scope ---

  Scenario: Tasks with same contextId are part of same conversational session
    Given a valid A2A server
    And multiple tasks exist with contextId "ctx-session-1"
    Then all those tasks SHOULD be treated as part of the same conversational session

  Scenario: Messages with same contextId are part of same conversational session
    Given a valid A2A server
    When a client sends multiple Messages with contextId "ctx-session-1"
    Then all messages SHOULD be treated as part of the same conversational context

  Scenario: Agent may use contextId to maintain state across interactions
    Given a valid A2A server
    When a client sends a Message with contextId "ctx-session-1"
    And the client sends another Message with the same contextId "ctx-session-1"
    Then the agent MAY use the contextId to maintain conversational history across both interactions
