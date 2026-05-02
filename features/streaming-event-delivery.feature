Feature: Streaming Event Delivery (Section 3.5.2)
  Defines event ordering guarantees and multiple stream behavior.

  # --- Event Ordering ---

  Scenario: Events are delivered in the order they were generated
    Given a valid A2A server that supports streaming
    And a client is subscribed to a task
    When the task generates multiple events in sequence
    Then all events MUST be delivered in the order they were generated

  Scenario: Events must not be reordered during transmission
    Given a valid A2A server that supports streaming
    And a client is subscribed to a task
    When the task generates event A then event B then event C
    Then the client MUST receive event A before event B
    And the client MUST receive event B before event C
    And events MUST NOT be reordered during transmission

  Scenario: Event ordering is preserved regardless of protocol binding
    Given a valid A2A server using any protocol binding
    And a client is subscribed to a task
    When the task generates multiple events
    Then the events MUST be delivered in generation order regardless of the protocol binding

  # --- Multiple Streams Per Task ---

  Scenario: Agent may serve multiple concurrent streams for same task
    Given a valid A2A server that supports streaming
    And a task exists with status "working"
    When client A subscribes to the task
    And client B subscribes to the same task
    Then both streams MUST be active simultaneously

  Scenario: Events broadcast to all active streams for a task
    Given a valid A2A server that supports streaming
    And client A and client B are both subscribed to the same task
    When the task generates a status update event
    Then the event MUST be broadcast to client A's stream
    And the event MUST be broadcast to client B's stream

  Scenario: Each stream receives the same events in the same order
    Given a valid A2A server that supports streaming
    And client A and client B are both subscribed to the same task
    When the task generates events E1, E2, and E3
    Then client A MUST receive E1, E2, E3 in that order
    And client B MUST receive E1, E2, E3 in that order

  Scenario: Closing one stream does not affect other active streams
    Given a valid A2A server that supports streaming
    And client A and client B are both subscribed to the same task
    When client A closes their stream
    Then client B's stream MUST remain open and active
    And client B MUST continue to receive events

  Scenario: Task lifecycle is independent of any individual stream
    Given a valid A2A server that supports streaming
    And a client is subscribed to a task with status "working"
    When the client closes their stream
    Then the task MUST continue processing independently
    And the task lifecycle MUST NOT be affected by the stream closure

  Scenario: Same client with multiple connections receives events on all streams
    Given a valid A2A server that supports streaming
    And a single client opens two subscription streams for the same task
    When the task generates an event
    Then both streams MUST receive the event
