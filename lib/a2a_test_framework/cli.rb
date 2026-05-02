# frozen_string_literal: true

require "optparse"
require_relative "../a2a_test_framework"

module A2ATestFramework
  class CLI
    CATEGORIES = {
      "discovery" => %w[
        agent_discovery_test
        agent_card_caching_test
        agent_card_signing_test
      ],
      "send_message" => %w[
        send_message_test
      ],
      "streaming" => %w[
        send_streaming_message_test
        streaming_event_delivery_test
        subscribe_to_task_test
      ],
      "tasks" => %w[
        get_task_test
        list_tasks_test
        cancel_task_test
      ],
      "push_notifications" => %w[
        push_notification_delivery_test
        create_task_push_notification_config_test
        get_task_push_notification_config_test
        list_task_push_notification_configs_test
        delete_task_push_notification_config_test
      ],
      "errors" => %w[
        error_handling_test
        error_code_mappings_test
      ],
      "versioning" => %w[
        versioning_test
        versioning_responsibilities_test
        extension_versioning_test
      ],
      "security" => %w[
        security_considerations_test
        protocol_security_test
        authentication_authorization_test
        in_task_authorization_test
      ],
      "protocol" => %w[
        protocol_data_model_test
        json_rpc_binding_test
        http_rest_binding_test
        json_field_naming_test
        custom_binding_test
        protocol_selection_negotiation_test
        functional_equivalence_test
        iana_registrations_test
      ],
      "semantics" => %w[
        context_identifier_semantics_test
        task_identifier_semantics_test
        history_length_semantics_test
        field_presence_optionality_test
        idempotency_test
        multi_turn_conversation_test
        messages_and_artifacts_test
        timestamps_test
        service_parameters_test
        capability_validation_test
      ],
      "extended" => %w[
        get_extended_agent_card_test
      ],
    }.freeze

    def initialize(argv)
      @argv = argv
      @options = {
        url: ENV.fetch("A2A_BASE_URL", "http://localhost:9292"),
        binding: "rest",
        only: [],
        files: [],
      }
    end

    def run
      parse_options!

      ENV["A2A_BASE_URL"] = @options[:url]

      files = resolve_test_files
      if files.empty?
        $stderr.puts "No test files found matching the given criteria."
        exit 1
      end

      require "bundler/setup"
      require "scampi"
      Scampi.summary_on_exit

      files.each { |f| load f }
    end

    private

    def parse_options!
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: a2a-test [options] [test_files...]"
        opts.separator ""
        opts.separator "Run A2A protocol conformance tests against an A2A server implementation."
        opts.separator ""
        opts.separator "Options:"

        opts.on("--url URL", "Base URL of the A2A server (default: $A2A_BASE_URL or http://localhost:9292)") do |url|
          @options[:url] = url
        end

        opts.on("--binding BINDING", "Protocol binding to test: rest, grpc (default: rest)") do |binding|
          unless %w[rest grpc].include?(binding)
            $stderr.puts "Error: --binding must be 'rest' or 'grpc'"
            exit 1
          end
          @options[:binding] = binding
        end

        opts.on("--only CATEGORIES", "Comma-separated list of test categories to run") do |cats|
          @options[:only] = cats.split(",").map(&:strip)
          invalid = @options[:only] - CATEGORIES.keys
          unless invalid.empty?
            $stderr.puts "Error: unknown categories: #{invalid.join(', ')}"
            $stderr.puts "Available categories: #{CATEGORIES.keys.join(', ')}"
            exit 1
          end
        end

        opts.on("--list-categories", "List available test categories and exit") do
          puts "Available test categories:"
          puts ""
          CATEGORIES.each do |name, files|
            puts "  #{name}"
            files.each { |f| puts "    - #{f}" }
            puts ""
          end
          exit 0
        end

        opts.on("-v", "--version", "Print version and exit") do
          puts "a2a-test-framework #{A2ATestFramework::VERSION}"
          exit 0
        end

        opts.on("-h", "--help", "Show this help message") do
          puts opts
          exit 0
        end
      end

      parser.parse!(@argv)

      # Remaining arguments are test file paths
      @options[:files] = @argv.dup
    end

    def resolve_test_files
      # If specific file paths were provided, use those
      unless @options[:files].empty?
        return @options[:files].map { |f| File.expand_path(f) }.select { |f| File.exist?(f) }
      end

      binding_dir = File.join(A2ATestFramework::TESTS_DIR, @options[:binding])

      unless Dir.exist?(binding_dir)
        $stderr.puts "Error: test directory not found: #{binding_dir}"
        exit 1
      end

      if @options[:only].empty?
        # Run all tests for the binding
        Dir.glob(File.join(binding_dir, "**/*_test.rb")).sort
      else
        # Filter by category
        test_basenames = @options[:only].flat_map { |cat| CATEGORIES[cat] }.compact.uniq
        test_basenames.filter_map do |basename|
          path = File.join(binding_dir, "#{basename}.rb")
          path if File.exist?(path)
        end
      end
    end
  end
end
