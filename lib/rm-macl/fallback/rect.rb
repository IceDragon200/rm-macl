#
# rm-macl/lib/rm-macl/fallback-lib/rect.rb
#   by IceDragon
require 'rm-macl/macl-core'
module MACL
  module Fallback
    class Rect

      attr_reader :x, :y, :width, :height

      def x=(new_x)
        @x = new_x.to_i
      end

      def y=(new_y)
        @y = new_y.to_i
      end

      def width=(new_width)
        @width = [new_width.to_i, 0].max
      end

      def height=(new_height)
        @height = [new_height.to_i, 0].max
      end

      def set(*args)
        case args.size
        when 1
          arg, = args
          case arg
          when *self.class.rect_datatypes
            x, y, w, h = arg.to_a
          when Hash
            x, y, w, h = arg[:x], arg[:y], arg[:width], arg[:height]
          when Array
            x, y, w, h = *arg
          else
            raise(TypeError, "Expected type Rect, Hash or Array")
          end
        when 4
          x, y, w, h = *args
        else
          raise(ArgumentError,
                "Expected 1 or 4 arguments but recieved #{args.size}")
        end
        self.x, self.y, self.width, self.height = x, y, w, h
      end

      def to_a
        [x, y, width, height]
      end

      def empty
        set(0, 0, 0, 0)
      end

      def empty?
        return (width == 0 || height == 0)
      end

      def self.rect_datatypes
        [Rect]
      end

      alias :initialize :set

      private :initialize

    end
  end
end
MACL.register('macl/fallback/rect', '1.1.0')