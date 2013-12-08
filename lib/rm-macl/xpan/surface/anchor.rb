#
# rm-macl/lib/rm-macl/xpan/surface/anchor.rb
#   by IceDragon
##
# Surface (2D) - as of v 1.3 2D functions are appended with 0x2 followed
# by 2 HEX digits
# 0x2yx
#
# Surface3 - all 3d contract functions are appended with 0x3 followed by 3
# HEX digits
# 0x3zyx
#    ^
#   _Z___
#  |\  2 \
#  |1\____\
#  \ | 0  |
#< X\|____|
#      Y
#     \/
#
#   n - enum[    0   ,   1,   2,    3  ]
#   x - enum[disabled, left, mid, right]
#   y - enum[disabled, top, mid, bottom]
#   z - enum[disabled, floor, mid, ceil]
##
require 'rm-macl/macl-core'
require 'rm-macl/core_ext/module'
module MACL
  module Surface
    class Anchor

      attr_reader :x, :y, :z

      def initialize(x, y, z)
        @x, @y, @z = x.to_i, y.to_i, z.to_i
      end

      def x=(new_x)
        @x = [[new_x.to_i, 3].min, 0].max
      end

      def y=(new_y)
        @y = [[new_y.to_i, 3].min, 0].max
      end

      def z=(new_z)
        @z = [[new_z.to_i, 3].min, 0].max
      end

      def to_a
        return x, y, z
      end

      def [](index)
        case index
        when 0 then x
        when 1 then y
        when 2 then z
        else        raise IndexError, "index #{index} out of range"
        end
      end

      def []=(index, value)
        case index
        when 0 then self.x = value
        when 1 then self.y = value
        when 2 then self.z = value
        else        raise IndexError, "index #{index} out of range"
        end
      end

      tcast_set(Integer) do |i|
        # hex-format
        if i >= 0x3000
          z = (i & 0x0F00) >> 8
          y = (i & 0x00F0) >> 4
          x = (i & 0x000F) >> 0
          new(x, y, z)
        elsif i >= 0x200
          y = (i & 0x0F0) >> 4
          x = (i & 0x00F) >> 0
          new(x, y, 0)
        # NUMPAD format
        else
          case i
          when 0      then new(0, 0, 0)
          when 1      then new(1, 3, 0)
          when 2      then new(2, 3, 0)
          when 3      then new(3, 3, 0)
          when 4      then new(1, 2, 0)
          when 5      then new(2, 2, 0)
          when 6      then new(3, 2, 0)
          when 7      then new(1, 1, 0)
          when 8      then new(2, 1, 0)
          when 9      then new(3, 1, 0)
          when 28, 82 then new(0, 2, 0)
          when 46, 64 then new(2, 0, 0)
          end
        end
      end

      tcast_set(Array)                   { |(x, y, z)| new(x, y, z) }

      tcast_set(String) do |string|
        words = string.split(" ")
        x = if words.include?("left")       then 1
            elsif words.include?("center")  then 2
            elsif words.include?("right")   then 3
            else                                 0
            end
        y = if words.include?("top")        then 1
            elsif words.include?("middle")  then 2
            elsif words.include?("bottom")  then 3
            else                                 0
            end
        z = if words.include?("back")       then 1
            elsif words.include?("central") then 2
            elsif words.include?("front")   then 3
            else                                 0
            end
        new(x, y, z)
      end

      tcast_set(Symbol) do |symbol|
        case symbol
        when :nw   then new(1, 1, 0)
        when :n    then new(2, 1, 0)
        when :ne   then new(3, 1, 0)
        when :sw   then new(1, 3, 0)
        when :s    then new(1, 3, 0)
        when :se   then new(2, 3, 0)
        when :w    then new(1, 2, 0)
        when :e    then new(3, 2, 0)
        when :horz then new(2, 0, 0)
        when :vert then new(0, 2, 0)
        end
      end

      tcast_set(:default)                { |o| o.to_anchor }

    end
  end
end