#
# rm-macl/lib/rm-macl/xpan/geometry.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/xpan/vector'
module MACL #:nodoc:
  module Geometry

  end
end
require 'rm-macl/xpan/geometry/path'
require 'rm-macl/xpan/geometry/line'
require 'rm-macl/xpan/geometry/angle'
require 'rm-macl/xpan/geometry/rectangle'
require 'rm-macl/xpan/geometry/square'
require 'rm-macl/xpan/geometry/ellipse'
require 'rm-macl/xpan/geometry/polygon'
require 'rm-macl/xpan/geometry/circle'
MACL.register('macl/xpan/geometry', "1.2.0")