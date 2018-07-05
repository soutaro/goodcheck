class Goodcheck::Location
  attr_reader start_line: Integer
  attr_reader start_column: Integer
  attr_reader end_line: Integer
  attr_reader end_column: Integer

  def initialize: (start_line: Integer, start_column: Integer, end_line: Integer, end_column: Integer) -> any
  def ==: (any) -> any
end
