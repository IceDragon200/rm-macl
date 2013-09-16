#
# RGSS3-MACL/lib/xpan-lib/geometry/square.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 18/04/2013
# vr 1.1.0
require File.join(File.dirname(__FILE__), 'rectangle')

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
