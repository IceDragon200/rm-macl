#
# RGSS3-MACL/lib/xpan-lib/surface.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/04/2013
# vr 1.4.0
module MACL
  class Surface

    VERSION = '1.4.0'.freeze

  end
end

require_relative 'surface/constants.rb'

require_relative 'surface/msurface.rb'
require_relative 'surface/msurface-exfunc.rb'
require_relative 'surface/surface-error.rb'
require_relative 'surface/surface.rb'
require_relative 'surface/surface_to.rb'
require_relative 'surface/surface-tools.rb'

require_relative 'surface/msurface3d.rb'
require_relative 'surface/msurface3d-exfunc.rb'
require_relative 'surface/surface3d.rb'
