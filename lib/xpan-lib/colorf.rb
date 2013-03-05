#
# RGSS3-MACL/lib/xpan-lib/colorf.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 05/03/2013
# vr 1.1.0
#   Using floats instead of integers
#
# CHANGES
#   05/03/2013 (vr 1.1.0)
#     new-method
#       to_color24
#       to_color32
#     new-alias
#       to_color32 => to_color
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

  def to_color24
    return Color.new(red * 255, green * 255, blue * 255, 255)
  end

  def to_color32
    return Color.new(red * 255, green * 255, blue * 255, alpha * 255)
  end

  alias :initialize :set
  alias :to_color :to_color32

end
