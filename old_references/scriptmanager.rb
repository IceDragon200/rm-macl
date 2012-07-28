#==============================================================================#
# ■ ScriptManager (Obsolete)
#==============================================================================#
# // • Created By    : IceDragon
# // • Modified By   : IceDragon
# // • Data Created  : 12/06/2011
# // • Data Modified : 01/28/2012
# // • Version       : 1.0
#==============================================================================#
# ● Guide 
# ● (V1.0)
#     ♦ ScriptManager.imported?( name )
#       Checks if a script has been imported 
#         ● Parameters
#             name (String)
#         ● Return : Bool 
#
#     ♦ ScriptManager.export( name )
#       Exports a script, by default the script is enabled (enable( name ))
#         ● Parameters
#             name (String)  
#         ● Return : self
#            
#     ♦ ScriptManager.enable( name )
#       Marks a script as enabled, can also be used to quickly export a script
#         ● Parameters
#             name (String) 
#         ● Return : self
#            
#     ♦ ScriptManager.disable( name )
#       Marks a script as disabled, can also be used to quickly export a script
#         ● Parameters
#             name (String) 
#         ● Return : self
#            
#     ♦ ScriptManager.enabled?( name )
#       Checks if an imported script has been enabled
#         ● Parameters
#             name (String) 
#         ● Return : Bool 
#            
#     ♦ ScriptManager.disabled?( name )
#       Checks if an imported script has been disabled
#         ● Parameters
#             name (String) 
#         ● Return : Bool 
#            
#==============================================================================#
# ● Change Log
#     ♣ 12/06/2011 V1.0  : Started
#     ♣ 01/28/2012 V1.0  : Renamed import (to) export 
#
#==============================================================================#
module ScriptManager
  @imported = {}
  def self.imported?( name )
    return @imported.has_key?( name )
  end
  def self.export( name )
    enable( name )
    self
  end
  def self.enable( name )
    @imported[name] = true
    self
  end
  def self.disable( name )
    @imported[name] = false
    self
  end  
  def self.enabled?( name )
    @imported[name] == true
  end
  def self.disabled?( name )
    @imported[name] == false
  end
end
#=■==========================================================================■=#
#                           // ● End of File ● //                              #
#=■==========================================================================■=#