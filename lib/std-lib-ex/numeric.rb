#
# RGSS3-MACL/lib/std-lib-ex/numeric.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.1.2
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
  end unless method_defined?(:count)

  def negative?
    self < 0
  end unless method_defined?(:negative?)

  def positive?
    self > 0
  end unless method_defined?(:positive?)

  ##
  # min(Numeric n)
  def min(n)
    n < self ? n : self
  end unless method_defined? :min

  ##
  # max(Numeric n)
  def max(n)
    n > self ? n : self
  end unless method_defined? :max

  ##
  # clamp(Numeric flr, Numeric cil)
  def clamp(flr, cil)
    self < flr ? flr : (self > cil ? cil : self)
  end unless method_defined? :clamp

  def signum
    self <=> 0
  end unless method_defined?(:signum)

  def signum_inv
    -(self <=> 0)
  end unless method_defined?(:signum_inv)

  ##
  # wall(Numeric other)
  #   Bounces self back from other if greater than
  def wall(other)
    self > other ? other - self % other : self
  end unless method_defined?(:wall)

end
