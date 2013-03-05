#
# RGSS3-MACL/lib/rgss-core-ex/color.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.2.1
class Color

  def self.rgb32(pixeli)
    return new((pixeli >> 24) & 0xFF, # red
               (pixeli >> 16) & 0xFF, # green
               (pixeli >> 8)  & 0xFF, # blue
               (pixeli     )  & 0xFF) # alpha
  end

  def self.rgb24(pixeli)
    return new((pixeli >> 16) & 0xFF, # red
               (pixeli >> 8)  & 0xFF, # green
               (pixeli)       & 0xFF) # blue
  end

  def self.rgb16(pixeli)
    return new(((pixeli >> 12) & 0xF) * 0xF, # red
               ((pixeli >> 8)  & 0xF) * 0xF, # green
               ((pixeli >> 4)  & 0xF) * 0xF, # blue
               ((pixeli     )  & 0xF) * 0xF) # alpha
  end

  def self.rgb12(pixeli)
    return new(((pixeli >> 8) & 0xF) * 0xF, # red
               ((pixeli >> 4) & 0xF) * 0xF, # green
               ((pixeli     ) & 0xF) * 0xF) # blue
  end

  def hash
    [self.red, self.green, self.blue, self.alpha].hash
  end unless method_defined?(:hash)

  def rgb_sym
    return :red, :green, :blue
  end unless method_defined?(:rgb_sym)

  def to_a
    return [self.red, self.green, self.blue, self.alpha]
  end unless method_defined?(:to_a)

  def to_a_na
    return to_a[0, 3]
  end unless method_defined?(:to_a_na)

  def to_rgb24
    return (red << 16) + (green << 8) + (blue)
  end unless method_defined?(:to_rgb24)

  def to_rgb12
    return ((red / 0xF) << 8) + ((green / 0xF) << 4) + (blue / 0xF)
  end unless method_defined?(:to_rgb12)

  def to_color
    return Color.new(*to_a)
  end unless method_defined?(:to_color)

  def to_colorf
    return MACL::ColorF.from_color(self)
  end unless method_defined?(:to_colorf)

  def to_tone
    return Tone.new(*to_a_na)
  end unless method_defined?(:to_tone)

  def to_h
    return { red: red, green: green, blue: blue, alpha: alpha }
  end unless method_defined?(:to_h)

  # interfacing for Color/Tone
  alias_method(:to_a_ng, :to_a_na) unless method_defined?(:to_a_ng)

end