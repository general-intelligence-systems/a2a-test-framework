Feature: IANA Registrations (Section 14)
  Media type, HTTP header, and well-known URI registrations for A2A.

  # --- Media Type (14.1.1) ---

  Scenario: application/a2a+json uses UTF-8 encoding
    Given an A2A server using application/a2a+json media type
    Then UTF-8 encoding MUST be used for JSON text

  Scenario: Content must be validated against A2A protocol schema
    Given an A2A server receiving application/a2a+json content
    Then the content MUST be validated against the A2A protocol schema before processing

  Scenario: Implementations must sanitize user-provided content
    Given an A2A server receiving application/a2a+json content
    Then implementations MUST sanitize user-provided content to prevent injection attacks

  Scenario: File references must be validated to prevent SSRF
    Given an A2A server processing message parts with file references
    Then file references within A2A messages MUST be validated to prevent SSRF

  # --- A2A-Version Header (14.2.1) ---

  Scenario: A2A-Version header value must be Major.Minor format
    Given a valid A2A client
    When the client includes the A2A-Version header
    Then the value MUST be in the format "Major.Minor" (e.g., "0.3", "1.0")

  # --- Well-Known URI (14.3) ---

  Scenario: well-known/agent-card.json must return AgentCard object
    Given a valid A2A server
    When a client requests /.well-known/agent-card.json
    Then the resource MUST return an AgentCard object as defined in the specification

  Scenario: Agent Card should not include sensitive credentials
    Given a valid A2A server publishing an Agent Card at the well-known URI
    Then the Agent Card SHOULD NOT include sensitive credentials or internal implementation details

  Scenario: Implementations should support HTTPS for Agent Card
    Given a valid A2A server
    Then implementations SHOULD support HTTPS to ensure authenticity and integrity of the Agent Card
