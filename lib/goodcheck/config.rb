module Goodcheck
  class Config
    # @dynamic rules
    attr_reader :rules

    def initialize(rules:)
      @rules = rules
    end

    def rules_for_path(path, rules_filter:)
      if block_given?
        # @type var pairs: Array<[Rule, String?]>

        pairs = _ = rules.map do |rule|
          # @type block: [Rule, String?]?
          if rules_filter.empty? || rules_filter.any? {|filter| /\A#{Regexp.escape(filter)}\.?/ =~ rule.id }
            if rule.globs.empty?
              [rule, nil]
            else
              glob = rule.globs.find {|glob| path.fnmatch?(glob.pattern, File::FNM_PATHNAME | File::FNM_EXTGLOB) }
              if glob
                [rule, glob]
              end
            end
          end
        end.compact

        pairs.each do |rule, glob|
          yield rule, glob
        end
      else
        enum_for(:rules_for_path, path, rules_filter: rules_filter)
      end
    end
  end
end
