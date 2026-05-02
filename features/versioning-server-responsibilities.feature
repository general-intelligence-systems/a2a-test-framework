Feature: Versioning - Server Responsibilities (Section 3.6.2)
  Agents MUST process requests using the semantics of the requested A2A-Version.

  Scenario: Server processes request using semantics of requested version
    Given a valid A2A server supporting versions "0.3" and "1.0"
    When a client sends a request with A2A-Version "1.0"
    Then the server MUST process the request using version 1.0 semantics

  Scenario: Server processes request using older version semantics when requested
    Given a valid A2A server supporting versions "0.3" and "1.0"
    When a client sends a request with A2A-Version "0.3"
    Then the server MUST process the request using version 0.3 semantics

  Scenario: Server returns VersionNotSupportedError for unsupported version
    Given a valid A2A server supporting only version "1.0"
    When a client sends a request with A2A-Version "2.0"
    Then the server MUST return a VersionNotSupportedError

  Scenario: Server interprets empty A2A-Version value as version 0.3
    Given a valid A2A server supporting version "0.3"
    When a client sends a request with an empty A2A-Version value
    Then the server MUST interpret the empty value as version 0.3
    And MUST process the request using version 0.3 semantics

  Scenario: Server interprets missing A2A-Version header as version 0.3
    Given a valid A2A server supporting version "0.3"
    When a client sends a request without an A2A-Version header
    Then the server MUST interpret this as version 0.3

  Scenario: Server may expose multiple version interfaces on same transport
    Given a valid A2A server
    Then the server MAY expose multiple interfaces for the same transport with different versions
