#
# RGSS3-MACL/lib/mixin/color-math.rb
#   by IceDragon
#   dc 09/03/2013
#   dm 09/03/2013
# vr 1.0.0
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
  # lerp!(Color trg_color, Rate r)
  #   r 0.0..1.0
  def lerp!(trg_color, r)
    self.red   = self.red   + (trg_color.red   - self.red)   * r
    self.green = self.green + (trg_color.green - self.green) * r
    self.blue  = self.blue  + (trg_color.blue  - self.blue)  * r
    return self
  end

  ##
  # lerp(Color trg_color, Rate r)
  def lerp(trg_color, r)
    return dup.lerp!(trg_color, r)
  end

  {add: :+, sub: :-, mul: :*, div: :/, replace: ''}.map do |(word, sym)|
    str = sym.empty? ? "arg.%1$s * delta" : "((self.%1$s_r #{sym} arg.%1$s_r * delta) * 255).to_i"
    module_eval(%Q(
      def #{word}!(arg)
        case arg
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

  def negate!
    self.red   = 0xFF - self.red
    self.blue  = 0xFF - self.blue
    self.green = 0xFF - self.green
    return self
  end

  def affirm!
    # nothing
    return self
  end

  def -@
    return dup.negate!
  end

  def +@
    return dup.affirm!
  end

  alias :+ :add
  alias :- :sub
  alias :* :mul
  alias :/ :div

end
end
end
