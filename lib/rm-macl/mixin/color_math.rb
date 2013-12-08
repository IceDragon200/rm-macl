#
# rm-macl/lib/rm-macl/mixin/color-math.rb
#   by IceDragon
require 'rm-macl/macl-core'
module MACL
  module Mixin
    module ColorMath

      ##
      # alpha_r -> Rate
      def alpha_r
        return self.alpha / 255.0
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
        color = Convert.Color(arg)
        self.red   += (color.red   * color.alpha) / 255
        self.green += (color.green * color.alpha) / 255
        self.blue  += (color.blue  * color.alpha) / 255
        self
      end

      def sub!(arg)
        color = Convert.Color(arg)
        self.red   -= (color.red   * color.alpha) / 255
        self.green -= (color.green * color.alpha) / 255
        self.blue  -= (color.blue  * color.alpha) / 255
        self
      end

      def mul!(arg)
        ary = Convert.ColorArray4(arg)
        self.red   = self.red   * ((ary[0] * ary[3]) / 255)
        self.green = self.green * ((ary[1] * ary[3]) / 255)
        self.blue  = self.blue  * ((ary[2] * ary[3]) / 255)
        self
      end

      def div!(arg)
        ary = Convert.ColorArray4(arg)
        self.red   = self.red   / ((ary[0] * ary[3]) / 255).max(1)
        self.green = self.green / ((ary[1] * ary[3]) / 255).max(1)
        self.blue  = self.blue  / ((ary[2] * ary[3]) / 255).max(1)
        self
      end

      ##
      # negate!
      def negate!
        self.red   = self.red ^ 255
        self.blue  = self.blue ^ 255
        self.green = self.green ^ 255
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
MACL.register('macl/mixin/color_math', '1.2.0')