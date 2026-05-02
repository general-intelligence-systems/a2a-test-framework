Feature: Authentication and Authorization (Sections 7.2-7.6.1)
  A2A servers must authenticate requests and authorize access.
  In-task authorization enables agents to request credentials from clients.

  # --- Server Identity Verification (7.2) ---

  Scenario: Client should verify server TLS certificate
    Given a production A2A server with a valid TLS certificate
    When a client establishes a connection
    Then the client SHOULD verify the server's TLS certificate against trusted CAs

  # --- Server Authentication Responsibilities (7.4) ---

  Scenario: Server must authenticate every incoming request
    Given a valid A2A server that requires authentication
    When any request is received
    Then the server MUST authenticate the request based on provided credentials

  Scenario: Server should use appropriate error codes for auth challenges
    Given a valid A2A server that requires authentication
    When a request fails authentication
    Then the server SHOULD use appropriate binding-specific error codes

  Scenario: Server should provide authentication challenge information
    Given a valid A2A server that requires authentication
    When a request fails authentication
    Then the server SHOULD provide relevant authentication challenge information with the error response

  # --- In-Task Authorization Agent Responsibilities (7.6.1) ---

  Scenario: Agent must use a Task to track operation requiring authorization
    Given a valid A2A server
    When the agent requires authorization during task processing
    Then the agent MUST use a Task to track the operation

  Scenario: Agent must transition to TASK_STATE_AUTH_REQUIRED
    Given a valid A2A server
    And a task is in progress
    When the agent requires authorization from the client
    Then the agent MUST transition the TaskState to TASK_STATE_AUTH_REQUIRED

  Scenario: Agent must include status message explaining required authorization
    Given a valid A2A server
    And a task is in progress
    When the agent transitions to TASK_STATE_AUTH_REQUIRED
    Then the agent MUST include a TaskStatus message explaining the required authorization
    Unless the details have been negotiated out-of-band or via an extension

  Scenario: Agent must arrange to receive credentials out-of-band
    Given a valid A2A server
    When the agent requires authorization from the client
    Then the agent MUST arrange to receive credentials via an out-of-band means
    Unless an in-band mechanism has been negotiated

  Scenario: Agent should maintain active streams during auth_required state
    Given a valid A2A server that supports streaming
    And a client is subscribed to a task
    When the agent transitions to TASK_STATE_AUTH_REQUIRED
    And the credential will be received out-of-band
    Then the agent SHOULD maintain the active response stream with the client

  Scenario: Agent may continue processing after receiving credential without client message
    Given a valid A2A server
    And a task is in TASK_STATE_AUTH_REQUIRED
    When the credential is received out-of-band
    Then the agent MAY immediately continue Task processing
    And the agent does not require clients to send a follow-up message

  Scenario: Agent should support receiving messages during auth_required
    Given a valid A2A server
    And a task is in TASK_STATE_AUTH_REQUIRED
    When a client sends a message directed to that Task
    Then the agent SHOULD accept and process the message
    And this enables clients to negotiate, correct, or reject the authorization request
