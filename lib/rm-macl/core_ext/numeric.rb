#
# rm-macl/lib/rm-macl/core_ext/numeric.rb
#   by IceDragon
require 'rm-macl/macl-core'
class Numeric

  ##
  # negative?
  #   is this Numeric negative?
  def negative?
    self < 0
  end unless method_defined? :negative?

  ##
  # positive?
  #   is this Numeric positive?
  def positive?
    self > 0
  end unless method_defined? :positive?

  ##
  # min(Numeric n)
  #   picks the smallest of (self) and (n)
  def min(n)
    n < self ? n : self
  end unless method_defined? :min

  ##
  # max(Numeric n)
  #   picks the largest of (self) and (n)
  def max(n)
    n > self ? n : self
  end unless method_defined? :max

  ##
  # clamp(Numeric flr, Numeric cil)
  #   limits (self) in range of flr..cil
  def clamp(flr, cil)
    (self < flr) ? flr : ((self > cil) ? cil : self)
  end unless method_defined? :clamp

  ##
  # signum -> int
  #   return 1  if (self) > 0
  #   return -1 if (self) < 0
  #   return 0  otherwise
  def signum
    self <=> 0
  end unless method_defined? :signum

  ##
  # signum_inv -> int
  #   return -1 if (self) > 0
  #   return 1  if (self) < 0
  #   return 0  otherwise
  def signum_inv
    -(self <=> 0)
  end unless method_defined? :signum_inv

  ##
  # wall(Numeric other)
  #   Bounces (self) back from (other) if greater than
  def wall(other)
    self > other ? other - self % other : self
  end unless method_defined? :wall

  ##
  # reflect(Numeric wall1, Numeric wall2)
  #   modulates (self) within the range of wall1...wall2
  def reflect(wall1, wall2)
    d = (wall2 - wall1).abs
    return ((self / d) % 2) == 0 ? wall1 + (self % d) : wall2 - (self % d)
  end

end
MACL.register('macl/core_ext/numeric', '1.4.0')