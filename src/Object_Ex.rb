#==============================================================================#
# ♥ Object (Expansion)
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
class Object
  def if_eql?(comp_obj,alt=nil)
    return self.eql?( comp_obj ) ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_eql? 
  def if_neql?( comp_obj, alt=nil )
    return (!self.eql?( comp_obj )) ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_neql? 
  def if_nil?( alt=nil )
    return self.nil? ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_nil?
  # // 01/31/2012
  def to_bool();!!self;end unless method_defined? :to_bool
end
#=■==========================================================================■=#
#                           // ● End of File ● //                              #
#=■==========================================================================■=#