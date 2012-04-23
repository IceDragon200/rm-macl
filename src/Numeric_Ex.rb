#==============================================================================#
# ♥ Numeric (Expansion)
#==============================================================================#
# // • Created By    : IceDragon
# // • Data Created  : 01/03/2012
# // • Data Modified : 01/04/2012
# // • Version       : 1.0
#==============================================================================#
# ● Change Log
#     Unknown
#
#==============================================================================#
class Numeric
  def min( n )
    n < self ? n : self
  end unless method_defined? :min   
  def max( n )
    n > self ? n : self
  end unless method_defined? :max   
  def minmax( m, mx )
    self.min(m).max(mx)
  end unless method_defined? :minmax
  def clamp( min, max )
    self < min ? min : (self > max ? max : self)
  end unless method_defined? :clamp 
  def pole()
    self <=> 0
  end unless method_defined? :pole
  def pole_inv()
    -pole
  end unless method_defined? :pole_inv
end
#=■==========================================================================■=#
#                           // ● End of File ● //                              #
#=■==========================================================================■=#