Feature: Protocol Versioning (Section 3.6)
  Protocol version is identified using Major.Minor elements.
  Patch version numbers do not affect protocol compatibility.

  # --- Version Format ---

  Scenario: Protocol version uses Major.Minor format
    Given a valid A2A server
    When a client sends a request with A2A-Version set to "1.0"
    Then the server MUST recognize this as a valid version format

  Scenario: Patch version numbers should not be used in requests
    Given a valid A2A client
    Then the client SHOULD NOT include patch version numbers in A2A-Version
    And the version SHOULD be expressed as "Major.Minor" only (e.g., "1.0" not "1.0.0")

  Scenario: Patch version numbers should not be used in responses
    Given a valid A2A server
    When the server returns version information
    Then patch version numbers SHOULD NOT be included

  Scenario: Patch version numbers should not be used in Agent Cards
    Given a valid A2A server publishing an AgentCard
    Then the version in the AgentCard SHOULD NOT include patch version numbers

  Scenario: Patch version must not be considered during version negotiation
    Given a valid A2A server supporting version "1.0"
    When a client sends a request with A2A-Version "1.0"
    Then the server MUST NOT consider patch version differences when negotiating
    And versions "1.0.0" and "1.0.1" of the spec MUST be treated as compatible
