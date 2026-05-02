Feature: Protocol Security (Section 7.1)
  Production deployments MUST use encrypted communication.

  Scenario: Production deployment must use HTTPS for HTTP-based bindings
    Given a production A2A server using an HTTP-based binding
    Then the server MUST use HTTPS (encrypted communication)
    And plain HTTP MUST NOT be used for production deployments

  Scenario: Production deployment must use TLS for gRPC bindings
    Given a production A2A server using the gRPC binding
    Then the server MUST use TLS for encrypted communication

  Scenario: Implementations should use modern TLS configurations
    Given a production A2A server
    Then the server SHOULD use TLS 1.3 or higher
    And the server SHOULD use strong cipher suites
