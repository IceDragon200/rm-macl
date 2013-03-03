#
# RGSS3-MACL/lib/rgss-core-ex/tone.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.1.1
class Tone

  def rgb_sym
    return :red, :green, :blue
  end unless method_defined?(:rgb_sym)

  def to_a
    return [self.red, self.green, self.blue, self.gray]
  end unless method_defined?(:to_a)

  def to_a_ng
    return to_a[0, 3]
  end unless method_defined?(:to_a_ng)

  def to_rgb24
    return (red << 16) + (green << 8) + (blue)
  end unless method_defined?(:to_rgb24)

  def to_rgb12
    return ((red / 0xF) << 8) + ((green / 0xF) << 4) + (blue / 0xF)
  end unless method_defined?(:to_rgb12)

  def to_color
    return Color.new(*to_a_ng)
  end unless method_defined?(:to_color)

  def to_tone
    return Tone.new(*to_a)
  end unless method_defined?(:to_tone)

  def to_h
    return { red: red, green: green, blue: blue, grey: grey }
  end unless method_defined?(:to_h)

  # interfacing for Color/Tone
  alias_method(:to_a_na, :to_a_ng) unless method_defined?(:to_a_na)

end
