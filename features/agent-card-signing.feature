Feature: Agent Card Signing (Sections 8.4-8.4.3)
  Agent Cards MAY be digitally signed using JWS. Signatures ensure
  authenticity and integrity.

  # --- Canonicalization Requirements (8.4.1) ---

  Scenario: Agent Card must be canonicalized using JCS (RFC 8785) before signing
    Given an Agent Card to be signed
    Then the content MUST be canonicalized using JSON Canonicalization Scheme (RFC 8785)

  Scenario: Optional fields not explicitly set must be omitted before canonicalization
    Given an Agent Card with optional fields not explicitly set
    When preparing for signing
    Then fields marked with optional keyword that were not explicitly set MUST be omitted from the JSON

  Scenario: Optional fields explicitly set to defaults must be included
    Given an Agent Card with optional field "streaming" explicitly set to false
    When preparing for signing
    Then the field MUST be included in the JSON object even though it matches the default

  Scenario: Required fields must always be present in canonical form
    Given an Agent Card with required fields
    When preparing for signing
    Then required fields MUST always be present even if the field value matches a default

  Scenario: Properties ordered lexicographically per RFC 8785
    Given an Agent Card being canonicalized
    Then object properties MUST be ordered lexicographically by key

  Scenario: Insignificant whitespace removed per RFC 8785
    Given an Agent Card being canonicalized
    Then insignificant whitespace MUST be removed

  Scenario: Signatures field excluded from content being signed
    Given an Agent Card with existing signatures
    When computing a new signature
    Then the signatures field MUST be excluded from the content being signed

  # --- Signature Format (8.4.2) ---

  Scenario: Protected header must include alg parameter
    Given a signed Agent Card
    Then the JWS protected header MUST include the "alg" parameter

  Scenario: Protected header must include kid parameter
    Given a signed Agent Card
    Then the JWS protected header MUST include the "kid" parameter

  Scenario: Protected header should include typ as JOSE
    Given a signed Agent Card
    Then the JWS protected header SHOULD have "typ" set to "JOSE"

  Scenario: Protected field is base64url-encoded JSON
    Given a signed Agent Card
    Then the "protected" field MUST be a base64url-encoded JSON object

  Scenario: Signature field is base64url-encoded signature value
    Given a signed Agent Card
    Then the "signature" field MUST be a base64url-encoded signature value

  # --- Signature Verification (8.4.3) ---

  Scenario: Client must follow verification steps in order
    Given a client verifying an Agent Card signature
    Then the client MUST extract the signature from the signatures array
    And retrieve the public key using kid and jku
    And remove properties with default values from the received Agent Card
    And exclude the signatures field
    And canonicalize the resulting JSON using RFC 8785
    And verify the signature against the canonicalized payload

  Scenario: Client should verify at least one signature before trusting Agent Card
    Given a client receiving an Agent Card with signatures
    Then the client SHOULD verify at least one signature before trusting the Agent Card

  Scenario: Public keys should be retrieved over secure channels
    Given a client verifying an Agent Card signature
    When retrieving the public key via jku
    Then the public key SHOULD be retrieved over HTTPS

  Scenario: Expired or revoked keys must not be used for verification
    Given a client verifying an Agent Card signature
    And the signing key has been expired or revoked
    Then the expired or revoked key MUST NOT be used for verification

  Scenario: Multiple signatures may be present for key rotation
    Given an Agent Card with multiple signatures in the signatures array
    Then this is valid and MAY be used to support key rotation
