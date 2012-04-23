#==============================================================================#
# ? Kernel (Expansion)
#==============================================================================#
# // • Created By    : IceDragon
# // • Data Created  : 01/14/2012
# // • Data Modified : 01/14/2012
# // • Version       : 1.0
#==============================================================================#
module Kernel
  def load_data( filename )
    obj = nil
    File.open( filename, "rb" ) { |f| obj = Marshal.load(f) }
    obj
  end
  def save_data( obj, filename )
    File.open( filename, "wb" ) { |f| Marshal.dump(obj, f) }
  end
  def load_data_cin( filename )
    save_data( yield, filename ) unless FileTest.exist?(filename)
    load_data( filename )
  end
end
#=¦==========================================================================¦=#
#                           // ? End of File ? //                              #
#=¦==========================================================================¦=#