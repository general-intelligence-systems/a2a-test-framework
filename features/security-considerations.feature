Feature: Security Considerations (Section 13)
  Comprehensive security guidance for A2A implementations.

  # --- Data Access and Authorization Scoping (13.1) ---

  Scenario: Authorization checks on every operation request
    Given a valid A2A server
    Then the server MUST implement authorization checks on every A2A Protocol Operations request

  Scenario: Results scoped to caller's authorized access boundaries
    Given a valid A2A server
    When an authenticated client sends any request
    Then implementations MUST scope results to the caller's authorized access boundaries

  Scenario: Results scoped even without filter parameters
    Given a valid A2A server
    When a client sends a ListTasks request without contextId or other filters
    Then implementations MUST still scope results to the caller's authorized access boundaries

  Scenario: List Tasks only returns visible tasks
    Given a valid A2A server
    When an authenticated client sends a ListTasks request
    Then the response MUST only return tasks visible to the authenticated client

  Scenario: Get Task verifies client access
    Given a valid A2A server
    When an authenticated client sends a GetTask request
    Then the server MUST verify the client has access to the requested task

  Scenario: Authorization checks before database queries
    Given a valid A2A server
    When a request is received
    Then authorization checks MUST occur before any database queries
    And checks MUST NOT leak information about resources outside the caller's scope

  # --- Push Notification Security (13.2) ---

  Scenario: Agent must include auth credentials in webhook requests
    Given a valid A2A server sending webhook notifications
    Then the agent MUST include authentication credentials as specified in PushNotificationConfig

  Scenario: Agent should validate webhook URLs to prevent SSRF
    Given a valid A2A server
    When a client creates a push notification config with a webhook URL
    Then the agent SHOULD validate the URL to prevent SSRF attacks

  Scenario: Agent should reject private IP ranges for webhooks
    Given a valid A2A server
    When a client attempts to register a webhook with a private IP (e.g., 127.0.0.1, 10.0.0.1)
    Then the agent SHOULD reject the URL

  Scenario: Client must validate webhook authenticity
    Given a valid A2A client receiving push notifications
    When a webhook request is received
    Then the client MUST validate webhook authenticity using the provided authentication credentials

  Scenario: Client must respond with HTTP 2xx for successful receipt
    Given a valid A2A client receiving push notifications
    When a valid webhook notification is received
    Then the client MUST respond with an HTTP 2xx status code

  Scenario: Webhook URLs should use HTTPS
    Given a valid A2A client configuring push notifications
    Then webhook URLs SHOULD use HTTPS to protect payload confidentiality

  # --- Extended Agent Card Access Control (13.3) ---

  Scenario: Get Extended Agent Card must require authentication
    Given a valid A2A server with extendedAgentCard capability
    Then the Get Extended Agent Card operation MUST require authentication

  Scenario: Agent must validate permissions before returning privileged info
    Given a valid A2A server with extendedAgentCard capability
    When a client requests the extended agent card
    Then the agent MUST validate that the client has appropriate permissions

  # --- General Security Best Practices (13.4) ---

  Scenario: Production must use encrypted communication
    Given a production A2A server
    Then the server MUST use encrypted communication (HTTPS or TLS)

  Scenario: Agent must validate all input parameters
    Given a valid A2A server
    When a request is received
    Then the agent MUST validate all input parameters before processing

  Scenario: Credentials must be treated as secrets
    Given a valid A2A server handling credentials
    Then API keys, tokens, and other credentials MUST be treated as secrets

  Scenario: Logs must not include sensitive information
    Given a valid A2A server
    Then logs MUST NOT include sensitive information such as credentials or personal data
    Unless required and properly protected

  Scenario: Agents must comply with data protection regulations
    Given a valid A2A server
    Then the agent MUST comply with applicable data protection regulations

  Scenario: Custom bindings must address security in specification
    Given a custom A2A protocol binding
    Then the binding MUST address security considerations in its specification

  Scenario: Custom bindings must document authentication integration
    Given a custom A2A protocol binding
    Then the binding MUST document authentication integration and credential transmission
