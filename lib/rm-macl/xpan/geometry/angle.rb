#
# rm-macl/lib/rm-macl/xpan/geometry/angle.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/xpan/geometry/path'

module MACL
  module Geometry
    class Angle < Path

      attr_accessor :parent_index

      def initialize(p1, p2, p3)
        super(p1, p2, p3)
        @parent_index = 1
      end

      def parent_point
        @points[@parent_index]
      end

      def angle
        # TODO
      end

      def vertex
        # TODO
      end

    end
  end
end
