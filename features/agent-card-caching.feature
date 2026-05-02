Feature: Agent Card Caching (Sections 8.6-8.6.2)
  Servers and clients SHOULD use standard HTTP caching for Agent Cards.

  # --- Server Requirements (8.6.1) ---

  Scenario: Server should include Cache-Control header with max-age
    Given a valid A2A server serving an Agent Card via HTTP
    When a client fetches the Agent Card
    Then the response SHOULD include a Cache-Control header with a max-age directive

  Scenario: Server should include ETag header
    Given a valid A2A server serving an Agent Card via HTTP
    When a client fetches the Agent Card
    Then the response SHOULD include an ETag header
    And the ETag SHOULD be derived from the Agent Card's version field or a hash of content

  Scenario: Server may include Last-Modified header
    Given a valid A2A server serving an Agent Card via HTTP
    When a client fetches the Agent Card
    Then the response MAY include a Last-Modified header

  # --- Client Requirements (8.6.2) ---

  Scenario: Client should honor HTTP caching semantics (RFC 9111)
    Given a valid A2A client fetching Agent Cards
    Then the client SHOULD honor HTTP caching semantics as defined in RFC 9111

  Scenario: Client should use conditional requests for expired cached cards
    Given a valid A2A client with a cached Agent Card that has expired
    When the client re-fetches the Agent Card
    Then the client SHOULD use conditional requests (If-None-Match with ETag or If-Modified-Since)

  Scenario: Client may apply default cache duration when no headers present
    Given a valid A2A client
    When the server does not include caching headers in the Agent Card response
    Then the client MAY apply an implementation-specific default cache duration
