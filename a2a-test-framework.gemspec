# frozen_string_literal: true

require_relative "lib/a2a_test_framework/version"

Gem::Specification.new do |spec|
  spec.name          = "a2a-test-framework"
  spec.version       = A2ATestFramework::VERSION
  spec.authors       = ["Nathan"]
  spec.summary       = "Conformance test suite for A2A (Agent-to-Agent) protocol implementations"
  spec.description   = "A comprehensive test framework for validating A2A protocol server implementations. " \
                       "Includes tests for REST and gRPC bindings covering agent discovery, messaging, " \
                       "streaming, task management, push notifications, error handling, and more."
  spec.homepage      = "https://github.com/a2aproject/a2a-test-framework"
  spec.license       = "Apache-2.0"

  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir[
    "lib/**/*.rb",
    "tests/**/*.rb",
    "endpoints/**/*.json",
    "exe/a2a-test",
    "a2a.json",
    "a2a.proto",
  ]

  spec.bindir        = "exe"
  spec.executables   = ["a2a-test"]
  spec.require_paths = ["lib"]

  spec.add_dependency "scampi"
  spec.add_dependency "agent2agent"
end
