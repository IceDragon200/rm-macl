#
# RGSS3-MACL/lib/std-lib-ex/numeric.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.1.0
class Numeric

  ##
  # count(int n)
  def count(n=1)
    i = self
    loop do
      yield i
      i = i + n
    end
    i
  end

  def negative?
    self < 0
  end

  def positive?
    self > 0
  end

  def min(n)
    n < self ? n : self
  end unless method_defined? :min

  def max(n)
    n > self ? n : self
  end unless method_defined? :max

  def clamp(min, max)
    self < min ? min : (self > max ? max : self)
  end unless method_defined? :clamp

  def unary
    self <=> 0
  end unless method_defined? :unary

  def unary_inv
    -(self <=> 0)
  end unless method_defined? :unary_inv

end
