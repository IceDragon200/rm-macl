#
# rm-macl/lib/rm-macl/xpan/geometry/line.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/xpan/geometry/path'
module MACL
  module Geometry
    class Line < Path

      ##
      # initialize(Point p1, Point p2)
      def initialize(p1, p2)
        super(p1, p2)
      end

    end
  end
end
MACL.register('macl/xpan/geometry/line', '1.0.0')