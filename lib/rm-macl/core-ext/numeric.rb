#
# rm-macl/lib/rm-macl/core-ext/numeric.rb
#
require 'rm-macl/macl-core'
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

  ##
  # negative?
  def negative?
    self < 0
  end unless method_defined?(:negative?)

  ##
  # positive?
  def positive?
    self > 0
  end unless method_defined?(:positive?)

  ##
  # min(Numeric n)
  def min(n)
    n < self ? n : self
  end unless method_defined?(:min)

  ##
  # max(Numeric n)
  def max(n)
    n > self ? n : self
  end unless method_defined?(:max)

  ##
  # clamp(Numeric flr, Numeric cil)
  def clamp(flr, cil)
    (self < flr) ? flr : ((self > cil) ? cil : self)
  end unless method_defined?(:clamp)

  ##
  # signum -> int
  def signum
    self <=> 0
  end unless method_defined?(:signum)

  ##
  # signum_inv -> int
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
MACL.register('macl/core/numeric', '1.2.0')