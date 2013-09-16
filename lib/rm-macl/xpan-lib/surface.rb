#
# RGSS3-MACL/lib/xpan-lib/surface.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 16/09/2013
module MACL
  class Surface

  end
end
require 'rm-macl/xpan-lib/vector'
require 'rm-macl/xpan-lib/surface/constants'
require 'rm-macl/xpan-lib/surface/msurface'
require 'rm-macl/xpan-lib/surface/msurface-exfunc'
require 'rm-macl/xpan-lib/surface/msurface3d'
require 'rm-macl/xpan-lib/surface/msurface3d-exfunc'
require 'rm-macl/xpan-lib/surface/surface'
require 'rm-macl/xpan-lib/surface/surface-convert'
require 'rm-macl/xpan-lib/surface/surface3d'
require 'rm-macl/xpan-lib/surface/surface_error'
require 'rm-macl/xpan-lib/surface/surface_tool'
MACL.register('macl/xpan/surface', '1.5.0')