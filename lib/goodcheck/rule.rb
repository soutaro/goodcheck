module Goodcheck
  class Rule
    # @dynamic id, patterns, message, justifications, globs, passes, fails
    attr_reader :id
    attr_reader :patterns
    attr_reader :message
    attr_reader :justifications
    attr_reader :globs
    attr_reader :passes
    attr_reader :fails

    def initialize(id:, patterns:, message:, justifications:, globs:, fails:, passes:)
      @id = id
      @patterns = patterns
      @message = message
      @justifications = justifications
      @globs = globs
      @passes = passes
      @fails = fails
    end
  end
end
