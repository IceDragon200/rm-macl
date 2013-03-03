#
# RGSS3-MACL/lib/xpan-lib/colorf.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.01
#   Using the (0.0)...(1.0) scale rather than 0...255
class MACL::ColorF

  attr_reader :red, :green, :blue, :alpha

  def set(r=1.0, g=1.0, b=1.0, a=1.0)
    self.red, self.green, self.blue, self.alpha = r, g, b, a
  end

  [:red, :green, :blue, :alpha].each do |sym|
    module_eval(%Q(
      def #{sym}=(new_#{sym})
        @#{sym} = [[new_#{sym}.to_f, 0.0].max, 1.0].min
      end
    ))
  end

  def rate
    return red * green * blue
  end

  def rate_a
    return red * green * blue * alpha
  end

  alias :initialize :set

end
