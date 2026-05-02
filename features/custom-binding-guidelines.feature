Feature: Custom Binding Guidelines (Section 12)
  Custom protocol bindings MUST comply with all protocol binding requirements.

  # --- Binding Requirements (12.1) ---

  Scenario: Custom binding must implement all core operations
    Given a custom A2A protocol binding
    Then the binding MUST support all operations defined in Section 3

  Scenario: Custom binding must preserve data model
    Given a custom A2A protocol binding
    Then the binding MUST use data structures functionally equivalent to those in Section 4

  Scenario: Custom binding must maintain operation semantics
    Given a custom A2A protocol binding
    Then operations MUST behave consistently with the abstract operation definitions

  Scenario: Custom binding must provide comprehensive documentation
    Given a custom A2A protocol binding
    Then the binding MUST provide comprehensive documentation of the binding specification

  # --- Data Type Mappings (12.2) ---

  Scenario: Custom binding must provide clear Protocol Buffer type mappings
    Given a custom A2A protocol binding
    Then the binding MUST define how each Protocol Buffer message type is represented

  Scenario: Custom binding must follow timestamp conventions
    Given a custom A2A protocol binding
    Then timestamps MUST follow the conventions in Section 5.6.1

  # --- Service Parameter Transmission (12.3) ---

  Scenario: Custom binding must document service parameter transmission
    Given a custom A2A protocol binding
    Then the binding specification MUST document how service parameters are transmitted

  Scenario: Custom binding must address transmission mechanism
    Given a custom A2A protocol binding
    Then the binding specification MUST address the protocol-specific transmission mechanism

  # --- Error Mapping (12.4) ---

  Scenario: Custom binding must map all A2A-specific error types
    Given a custom A2A protocol binding
    Then the binding MUST provide mappings for all A2A-specific error types

  Scenario: Custom binding must preserve error information
    Given a custom A2A protocol binding
    Then the binding MUST ensure error details are accessible to clients

  # --- Streaming Support (12.5) ---

  Scenario: Custom binding without streaming must document limitation
    Given a custom A2A protocol binding that does not support streaming
    Then the binding MUST clearly document this limitation in the Agent Card

  # --- Authentication (12.6) ---

  Scenario: Custom binding must support authentication schemes from Agent Card
    Given a custom A2A protocol binding
    Then the binding MUST implement authentication schemes declared in the Agent Card

  # --- Agent Card Declaration (12.7) ---

  Scenario: Custom binding must be declared in Agent Card with URI identifier
    Given a custom A2A protocol binding
    Then the binding MUST be declared in the Agent Card
    And the protocolBinding field MUST use a URI to identify the binding

  Scenario: Custom binding must provide endpoint URL in Agent Card
    Given a custom A2A protocol binding
    Then the Agent Card entry MUST provide the full URL where the binding is available
