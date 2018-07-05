module Goodcheck
  class Glob
    # @dynamic pattern, encoding
    attr_reader :pattern
    attr_reader :encoding

    def initialize(pattern:, encoding:)
      @pattern = pattern
      @encoding = encoding
    end
  end
end
