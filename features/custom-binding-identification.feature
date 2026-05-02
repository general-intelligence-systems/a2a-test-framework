Feature: Custom Binding Identification (Section 5.8)
  Custom protocol bindings should be identified by a URI.
  Breaking changes require a new URI.

  Scenario: Custom binding should be identified by a URI
    Given a valid A2A server with a custom protocol binding
    Then the protocolBinding field in the AgentCard SHOULD be a URI

  Scenario: New URI must be used for breaking changes to a binding
    Given a custom protocol binding identified by "https://example.com/bindings/ws/v1"
    When a breaking change is introduced to the binding
    Then a new URI MUST be used (e.g., "https://example.com/bindings/ws/v2")
    And clients MUST be able to distinguish between incompatible versions

  Scenario: URI provides globally unique identification
    Given multiple implementers of custom protocol bindings
    Then each binding SHOULD use a URI as its identifier
    And the URI provides globally unique identification across all implementers
