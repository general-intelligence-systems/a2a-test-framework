Feature: Versioning - Client Responsibilities (Section 3.6.1)
  Clients MUST send the A2A-Version header with each request.

  Scenario: Client must send A2A-Version header with each request
    Given a valid A2A client
    When the client sends any request to an A2A server
    Then the request MUST include the A2A-Version header

  Scenario: Empty A2A-Version header is interpreted as version 0.3
    Given a valid A2A server
    When a client sends a request without an A2A-Version header
    Then the server MUST interpret the empty value as version 0.3

  Scenario: Client may provide A2A-Version as request parameter instead of header
    Given a valid A2A server
    When a client sends a request with A2A-Version as a query parameter "?A2A-Version=1.0"
    Then the server MUST accept this as equivalent to the A2A-Version header

  Scenario: A2A-Version header with value "1.0" is accepted
    Given a valid A2A server supporting version "1.0"
    When a client sends a request with A2A-Version header set to "1.0"
    Then the server MUST process the request using version 1.0 semantics
