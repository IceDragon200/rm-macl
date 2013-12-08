#
# rm-macl/lib/rm-macl/fallback-lib/tone.rb
#   by IceDragon
#   dc 01/04/2013
#   dc 01/04/2013
# vr 1.0.0
require 'rm-macl/macl-core'
module MACL
  module Fallback
    class Tone

      attr_reader :red, :green, :blue, :gray

      def red=(new_red)
        @red = [[new_red.to_i, 0xFF].min, -0xFF].max
      end

      def green=(new_green)
        @green = [[new_green.to_i, 0xFF].min, -0xFF].max
      end

      def blue=(new_blue)
        @blue = [[new_blue.to_i, 0xFF].min, -0xFF].max
      end

      def gray=(new_gray)
        @gray = [[new_gray.to_i, 0xFF].min, 0].max
      end

      def set(*args)
        case args.size
        when 1
          arg, = args
          case arg
          when *self.class.tone_datatypes
            r, g, b, a = arg.to_a
          when Hash
            r, g, b, a = arg[:red], arg[:green], arg[:blue], arg[:gray]
          when Array
            r, g, b, a = *arg
          else
            raise(TypeError, "Expected type Tone, Hash or Array")
          end
        when 3
          r, g, b = *args; a = 0x00
        when 4
          r, g, b, a = *args
        else
          raise(ArgumentError,
                "Expected 1, 3 or 4 arguments but recieved #{args.size}")
        end
        self.red, self.green, self.blue, self.gray = r, g, b, a
      end

      def to_a
        [red, green, blue, gray]
      end

      def self.tone_datatypes
        [Tone]
      end

      alias :initialize :set

      private :initialize

    end
  end
end
MACL.register('macl/fallback/tone', '1.1.0')