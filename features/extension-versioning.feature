Feature: Extension Versioning and Compatibility (Section 4.6.3)
  Extensions should include version information in their URI.
  A new URI must be created for breaking changes.

  # --- Version in URI ---

  Scenario: Extensions should include version information in their URI
    Given a valid A2A server with extensions declared in the AgentCard
    Then each extension URI SHOULD include version information (e.g., "/v1", "/v2")

  Scenario: New URI must be created for breaking changes to an extension
    Given an extension with URI "https://example.com/extensions/foo/v1"
    When a breaking change is made to the extension
    Then a new URI MUST be created (e.g., "https://example.com/extensions/foo/v2")
    And the old URI MUST NOT be reused for the incompatible version

  # --- Unsupported Extension Version Handling ---

  Scenario: Agent should ignore unsupported non-required extension
    Given a valid A2A server
    And the AgentCard declares extension "https://example.com/ext/v1" as not required
    When a client requests extension "https://example.com/ext/v2" which the agent does not support
    Then the agent SHOULD ignore the extension for that interaction
    And the agent SHOULD proceed without it

  Scenario: Agent must return error for unsupported required extension
    Given a valid A2A server
    And the AgentCard declares extension "https://example.com/ext/v1" as required
    When a client requests extension "https://example.com/ext/v2" which the agent does not support
    Then the agent MUST return an error indicating unsupported extension

  Scenario: Agent must not fall back to previous extension version automatically
    Given a valid A2A server
    And the AgentCard declares extension "https://example.com/ext/v1"
    When a client requests extension "https://example.com/ext/v2" which the agent does not support
    Then the agent MUST NOT fall back to version v1 of the extension automatically
