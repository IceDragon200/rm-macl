#
# rm-macl/lib/rm-macl/xpan/surface.rb
#
require 'rm-macl/macl-core'
module MACL
  class Surface

  end
end
require 'rm-macl/xpan/vector'
require 'rm-macl/xpan/surface/constants'
require 'rm-macl/xpan/surface/msurface'
require 'rm-macl/xpan/surface/msurface-exfunc'
require 'rm-macl/xpan/surface/msurface3'
require 'rm-macl/xpan/surface/msurface3-exfunc'
require 'rm-macl/xpan/surface/surface'
require 'rm-macl/xpan/surface/surface-convert'
require 'rm-macl/xpan/surface/surface3'
require 'rm-macl/xpan/surface/surface_error'
require 'rm-macl/xpan/surface/tool'
MACL.register('macl/xpan/surface', '1.5.0')