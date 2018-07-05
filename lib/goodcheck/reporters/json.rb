module Goodcheck
  module Reporters
    class JSON
      # @dynamic stdout, stderr, issues
      attr_reader :stdout
      attr_reader :stderr
      attr_reader :issues

      def initialize(stdout:, stderr:)
        @stdout = stdout
        @stderr = stderr
        @issues = []
      end

      def analysis
        stderr.puts "Starting analysis..."
        yield

        json = issues.map do |issue|
          {
            rule_id: issue.rule.id,
            path: issue.path,
            location: {
              start_line: issue.location.start_line,
              start_column: issue.location.start_column,
              end_line: issue.location.end_line,
              end_column: issue.location.end_column
            },
            message: issue.rule.message,
            justifications: issue.rule.justifications
          }
        end
        stdout.puts ::JSON.dump(json)
        json
      end

      def file(path)
        stderr.puts "Checking #{path}..."
        yield
      end

      def rule(rule)
        stderr.puts "  Checking #{rule.id}..."
        yield
      end

      def issue(issue)
        issues << issue
      end
    end
  end
end
