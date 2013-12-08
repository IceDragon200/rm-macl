#
# rm-macl/lib/rm-macl/xpan/geometry/square.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/xpan/geometry/rectangle'
module MACL
  module Geometry
    class Square < Rectangle

      ##
      # initialize=(Integer x, Integer y, Integer n)
      def initialize(x, y, w)
        super(x, y, w, w)
      end

      alias :org_width_set :width=
      alias :org_height_set :height=

      ##
      # width=(Integer n)
      def width=(n)
        super(n)
        org_height_set(n)
      end

      ##
      # height=(Integer n)
      def height=(n)
        super(n)
        org_width_set(n)
      end

    end
  end
end
MACL.register('macl/xpan/geometry/square', '1.2.0')