class Numeric
  def min(n)
    n < self ? n : self
  end unless method_defined? :min   
  def max(n)
    n > self ? n : self
  end unless method_defined? :max   
  def minmax(m, mx)
    self.min(m).max(mx)
  end unless method_defined? :minmax
  def clamp(min, max)
    self < min ? min : (self > max ? max : self)
  end unless method_defined? :clamp 
  def pole()
    self <=> 0
  end unless method_defined? :pole
  def pole_inv()
    -pole
  end unless method_defined? :pole_inv
end