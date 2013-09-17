#
# rm-macl/lib/rm-macl/xpan/geometry/circle.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 0.0.1
require 'rm-macl/xpan/geometry/ellipse'
module MACL
  module Geometry
    class Circle < Ellipse

      attr_reader :radius

      ##
      # initialize(Integer x, Integer y, Integer radius)
      def initialize(x=0, y=0, radius=0)
        super(x, y, 0, 0)
        self.radius = radius
      end

      ##
      # radius=(Integer n)
      def radius=(n)
        self.radius_x = self.radius_y = @radius = n
      end

      ##
      # set
      def set(*args)
        args.push(args[2]) if args.size == 3
        super(*args)
      end

    end
  end
end
