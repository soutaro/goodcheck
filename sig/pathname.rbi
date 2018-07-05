class Pathname
  def fnmatch?: (String, ?any) -> bool
  def read: -> String
          | (encoding: any) -> String
  def open: (?String) { (any) -> void } -> void
  def file?: -> bool
  def symlink?: -> bool
  def directory?: -> bool
  def children: -> Array<Pathname>
end

extension Object (Pathname)
  def Pathname: (String) -> Pathname
end

class Set<'a>
  def <<: ('a) -> self
  def include?: ('a) -> bool
end

extension Integer (Ordinalize)
  def ordinalize: -> String
end

extension String (Polyfill)
  def encoding: -> any
  def encode: (any) -> String
end

class Rainbow
  def red: -> String
end

extension Object (Rainbow)
  def Rainbow: (String) -> Rainbow
end
