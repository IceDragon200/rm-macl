#
# rm-macl/lib/rm-macl/xpan/geometry/square.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 18/04/2013
# vr 1.1.0
require 'rm-macl/xpan/geometry/rectangle'
module MACL
  module Geometry
    class Square < Rectangle

      ##
      # initialize=(Integer x, Integer y, Integer n)
      def initialize(x, y, w)
        super(x, y, w, w)
      end

      ##
      # width=(Integer n)
      def width=(n)
        @width = @height = n
      end

      ##
      # height=(Integer n)
      def height=(n)
        @width = @height = n
      end

    end
  end
end
