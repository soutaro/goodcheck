class Goodcheck::Buffer
  attr_reader path: Pathname
  attr_reader content: String
  attr_reader line_starts: Array<Range<Integer>>

  def initialize: (path: Pathname, content: String) -> any
  def location_for_position: (Integer) -> [Integer, Integer]
  def line: (Integer) -> String
  def position_for_location: (Integer, Integer) -> Integer
end

class Goodcheck::Pattern
  attr_reader source: String
  attr_reader regexp: Regexp

  def initialize: (source: String, regexp: Regexp) -> any

  def self.literal: (String, case_sensitive: bool) -> instance
  def self.regexp: (String, case_sensitive: bool, multiline: bool) -> instance
  def self.token: (String, case_sensitive: bool) -> instance
  def self.compile_tokens: (String, case_sensitive: bool) -> Regexp
end

class Goodcheck::Glob
  attr_reader pattern: String
  attr_reader encoding: String?

  def initialize: (pattern: String, encoding: String?) -> any
end

class Goodcheck::Rule
  attr_reader id: String
  attr_reader patterns: Array<Pattern>
  attr_reader message: String
  attr_reader justifications: Array<String>
  attr_reader globs: Array<Glob>
  attr_reader passes: Array<String>
  attr_reader fails: Array<String>

  def initialize: (id: String,
                   patterns: Array<Pattern>,
                   message: String,
                   justifications: Array<String>,
                   globs: Array<Glob>,
                   fails: Array<String>,
                   passes: Array<String>) -> any
end

class Goodcheck::Config
  attr_reader rules: Array<Rule>
  def initialize: (rules: Array<Rule>) -> any
  def rules_for_path: (Pathname, rules_filter: Array<String>) { (Rule, String?) -> void } -> Array<[Rule, String?]>
end

module Goodcheck::ArrayHelper : Object
  def array: (any) -> Array<any>
end

class Goodcheck::ConfigLoader
  include ArrayHelper

  attr_reader path: Pathname
  attr_reader content: Hash<Symbol, any>
  attr_reader stderr: any
  attr_reader printed_warnings: Set<String>

  def initialize: (path: Pathname, content: Hash<Symbol, any>, stderr: any) -> any
  def load: () -> any
  def load_rule: (any) -> Rule
  def load_globs: (any) -> Array<Glob>
  def load_pattern: (any) -> Pattern
  def case_sensitive?: (any) -> bool
  def print_warning_once: (String) -> void
end

Goodcheck::ConfigLoader::InvalidPattern: any
Goodcheck::ConfigLoader::Schema: any

class Goodcheck::Issue
  attr_reader buffer: Buffer
  attr_reader range: Range<Integer>
  attr_reader rule: Rule
  attr_reader text: String
  attr_reader location: Location

  def initialize: (buffer: Buffer, range: Range<Integer>, rule: Rule, text: String) -> any
  def path: () -> Pathname
  def location: () -> Location
end

class Goodcheck::Analyzer
  attr_reader rule: Rule
  attr_reader buffer: Buffer

  def initialize: (rule: Rule, buffer: Buffer) -> any
  def scan: { (Issue) -> void } -> void
end

interface _Reporter
  def analysis: { () -> void } -> void
  def file: (Pathname) { () -> void } -> void
  def rule: (Goodcheck::Rule) { () -> void } -> void
  def issue: (Goodcheck::Issue) -> void
end

class Goodcheck::Reporters::Text
  attr_reader stdout: any

  def initialize: (stdout: any) -> any

  def analysis: { () -> void } -> void
  def file: (Pathname) { () -> void } -> void
  def rule: (Rule) { () -> void } -> void
  def issue: (Issue) -> void
end

class Goodcheck::Reporters::JSON
  attr_reader stdout: any
  attr_reader stderr: any
  attr_reader issues: Array<Issue>

  def initialize: (stdout: any, stderr: any) -> any
  def analysis: { () -> void } -> Array<Hash<any, any>>
  def file: (Pathname) { () -> void } -> void
  def rule: (Rule) { () -> void } -> void
  def issue: (Issue) -> void
end

interface _WithConfig
  def config_path: -> Pathname
  def stdout: -> any
  def stderr: -> any
end

module Goodcheck::Commands::ConfigLoading : _WithConfig
  attr_reader config: Config
  def load_config!: () -> void
end

class Goodcheck::Commands::Test
  attr_reader stdout: any
  attr_reader stderr: any
  attr_reader config_path: Pathname

  include ConfigLoading

  def initialize: (stdout: any, stderr: any, config_path: Pathname) -> any

  def run: () -> Integer
  def validate_rule_uniqueness: () -> bool
  def validate_rules: () -> bool
  def rule_matches_example?: (Rule, String) -> bool
end

class Goodcheck::Commands::Init
  attr_reader stdout: any
  attr_reader stderr: any
  attr_reader path: Pathname
  attr_reader force: bool

  def initialize: (stdout: any, stderr: any, path: Pathname, force: bool) -> any
  def run: () -> Integer
end

Goodcheck::Commands::Init::CONFIG: String

class Goodcheck::Commands::Check
  attr_reader config_path: Pathname
  attr_reader rules: Array<String>
  attr_reader targets: Array<Pathname>
  attr_reader reporter: _Reporter
  attr_reader stderr: any

  include ConfigLoading

  def initialize: (config_path: Pathname,
                   rules: Array<String>,
                   targets: Array<Pathname>,
                   reporter: _Reporter,
                   stderr: any) -> any

  def run: () -> Integer
  def each_check: () { (Buffer, Rule) -> void } -> void
  def each_file: (Pathname, ?immediate: bool) { (Pathname) -> void } -> void
end

class Goodcheck::CLI
  attr_reader stdout: any
  attr_reader stderr: any

  def initialize: (stdout: any, stderr: any) -> any

  def run: (Array<String>) -> Integer
  def check: (Array<String>) -> Integer
  def test: (Array<String>) -> Integer
  def init: (Array<String>) -> Integer
  def version: (Array<String>) -> Integer
  def help: (Array<String>) -> Integer
end

Goodcheck::CLI::COMMANDS: Hash<Symbol, String>

Goodcheck::VERSION: String
