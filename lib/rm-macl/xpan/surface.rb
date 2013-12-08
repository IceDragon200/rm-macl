#
# rm-macl/lib/rm-macl/xpan/surface.rb
#   by IceDragon
require 'rm-macl/macl-core'
module MACL #:nodoc:
  module Surface
  end
end
require 'rm-macl/xpan/vector'
require 'rm-macl/xpan/surface/anchor'
require 'rm-macl/xpan/surface/constants'
require 'rm-macl/xpan/surface/msurface2'
require 'rm-macl/xpan/surface/msurface3'
require 'rm-macl/xpan/surface/surface2'
require 'rm-macl/xpan/surface/surface3'
require 'rm-macl/xpan/surface/surface_error'
require 'rm-macl/xpan/surface/tool'
MACL.register('macl/xpan/surface', '1.6.0')