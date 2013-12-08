#
# rm-macl/lib/rm-macl/mixin/tone-math.rb
#   by IceDragon
require 'rm-macl/macl-core'
module MACL
  module Mixin
    module ToneMath

      ##
      # gray_r -> Rate
      def gray_r
        return self.gray / 255.0
      end

      ##
      # red_r -> Rate
      def red_r
        return self.red / 255.0
      end

      ##
      # green_r -> Rate
      def green_r
        return self.green / 255.0
      end

      ##
      # blue_r -> Rate
      def blue_r
        return self.blue / 255.0
      end

      ##
      # lerp!(Color trg_color, Rate r) -> self
      #   r 0.0..1.0
      def lerp!(trg_color, r)
        self.red   = self.red   + (trg_color.red   - self.red)   * r
        self.green = self.green + (trg_color.green - self.green) * r
        self.blue  = self.blue  + (trg_color.blue  - self.blue)  * r
        return self
      end

      ##
      #
      def add!(arg)
        tone = Convert.Tone(arg)
        self.red   += tone.red
        self.green += tone.green
        self.blue  += tone.blue
        self
      end

      def sub!(arg)
        tone = Convert.Tone(arg)
        self.red   -= tone.red
        self.green -= tone.green
        self.blue  -= tone.blue
        self
      end

      def mul!(arg)
        tone = Convert.ToneArray3(arg)
        self.red   *= tone[0]
        self.green *= tone[1]
        self.blue  *= tone[2]
        self
      end

      def div!(arg)
        tone = Convert.ToneArray3(arg)
        self.red   /= tone[0] if tone[0] != 0
        self.green /= tone[1] if tone[1] != 0
        self.blue  /= tone[2] if tone[2] != 0
        self
      end

      ##
      # negate!
      def negate!
        self.red   = -self.red
        self.blue  = -self.blue
        self.green = -self.green
        return self
      end

      ##
      # affirm!
      def affirm!
        # nothing
        return self
      end

      def lerp(trg_color, r)
        dup.lerp!(trg_color, r)
      end

      def add(arg)
        dup.add!(arg)
      end

      def sub(arg)
        dup.sub!(arg)
      end

      def mul(arg)
        dup.mul!(arg)
      end

      def div(arg)
        dup.div!(arg)
      end

      ##
      # negate
      def negate
        dup.negate!
      end

      ##
      # affirm
      def affirm
        dup.affirm!
      end

      alias :+  :add
      alias :-  :sub
      alias :*  :mul
      alias :/  :div

      alias :-@ :negate
      alias :+@ :affirm

    end
  end
end
MACL.register('macl/mixin/tone_math', '1.0.0')