#
# RGSS3-MACL/lib/mixin/color-math.rb
#   by IceDragon
#   dc 09/03/2013
#   dm 06/06/2013
# vr 1.1.0
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
      # lerp(Color trg_color, Rate r) -> Color
      def lerp(trg_color, r)
        return dup.lerp!(trg_color, r)
      end

      ##
      # rgb_set(*args)
      def rgb_set(*args)
        org_alpha = self.alpha
        set(*args)
        self.alpha = org_alpha
        return self
      end

      ##
      # (add|sub|mul|div|replace)(Colorable color)
      # (add|sub|mul|div|replace)(Array<Integer>[:red, :green, :blue] values)
      # (add|sub|mul|div|replace)(Array<Integer>[:red, :green, :blue, :alpha] values)
      # (add|sub|mul|div|replace)(Numeric i)
      {add: :+, sub: :-, mul: :*, div: :/, replace: ''}.map do |(word, sym)|
        str = sym.empty? ? "arg.%1$s * delta" : "((self.%1$s_r #{sym} arg.%1$s_r * delta) * 255).to_i"
        ary_str = sym.empty? ? "%1$s * delta" : "((self.%2$s_r #{sym} (%1$s / 255.0) * delta) * 255).to_i"
        module_eval(%Q(
          def #{word}!(arg)
            case arg
            when Array
              if arg.size >= 3
                delta = (arg[3] || 255) / 255.0
                self.red   = #{ary_str % ['arg[0]', 'red']}
                self.green = #{ary_str % ['arg[1]', 'green']}
                self.blue  = #{ary_str % ['arg[2]', 'blue']}
              else
                raise(ArgumentError, "Expected Array of size 3 or 4 but recieved \%d" % arg.size)
              end
            when ColorMath
              delta = arg.alpha_r
              self.red   = #{str % 'red'}
              self.green = #{str % 'green'}
              self.blue  = #{str % 'blue'}
            when Numeric
              self.red   #{sym}= arg
              self.green #{sym}= arg
              self.blue  #{sym}= arg
            else
              raise(TypeError,
                    "Expected type #{self.to_s} or Numeric but recieved #{'#{arg.class}'}")
            end
            return self
          end

          def #{word}(arg)
            dup.#{word}!(arg)
          end
        ))
      end

      ##
      # negate!
      def negate!
        self.red   = 0xFF - self.red
        self.blue  = 0xFF - self.blue
        self.green = 0xFF - self.green
        return self
      end

      ##
      # affirm!
      def affirm!
        # nothing
        return self
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

      alias :+ :add
      alias :- :sub
      alias :* :mul
      alias :/ :div

      alias :-@ :negate
      alias :+@ :affirm

    end
  end
end
