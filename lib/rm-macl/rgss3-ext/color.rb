#
# rm-macl/lib/rm-macl/rgss-core-ex/color.rb
#   by IceDragon
require 'rm-macl/macl-core'
class Color

  ##
  # to_argb32 -> Integer
  #   0xAARRGGBB
  def to_argb32
    return (alpha.to_i << 24) | (red.to_i << 16) | (green.to_i << 8) | (blue.to_i << 0)
  end unless method_defined?(:to_argb32)

  ##
  # to_rgb24 -> Integer
  #   0xRRGGBB
  def to_rgb24
    return (red.to_i << 16) | (green.to_i << 8) | (blue.to_i << 0)
  end unless method_defined?(:to_rgb24)

  ##
  # to_argb16 -> Integer
  #   0xARGB
  def to_argb16
    return ((alpha.to_i / 0xF) << 12) | ((red.to_i / 0xF) << 8) | ((green.to_i / 0xF) << 4) | (blue.to_i / 0xF)
  end unless method_defined?(:to_argb16)

  ##
  # to_rgb12 -> Integer
  #   0xRGB
  def to_rgb12
    return ((red.to_i / 0xF) << 8) | ((green.to_i / 0xF) << 4) | (blue.to_i / 0xF)
  end unless method_defined?(:to_rgb12)

  ##
  # hash -> Bignum
  def hash
    [self.red, self.green, self.blue, self.alpha].hash
  end unless method_defined?(:hash)

  ##
  # rgb_sym -> Array<Symbols>
  def rgb_sym
    return [:red, :green, :blue]
  end unless method_defined?(:rgb_sym)

  ##
  # to_argb24_a -> Array<Integer>
  #   [alpha, red, green, blue]
  def to_argb32_a
    return [self.alpha, self.red, self.green, self.blue]
  end unless method_defined?(:to_argb32_a)

  ##
  # to_rgb24_a -> Array<Integer>
  #   [red, green, blue]
  def to_rgb24_a
    return to_a[0, 3]
  end unless method_defined?(:to_rgb24_a)

  ##
  # to_color -> Color
  def to_color
    return Color.new(*to_a)
  end unless method_defined?(:to_color)

  ##
  # to_colorf -> MACL::ColorVector
  def to_colorf
    return MACL::ColorVector.from_color(self)
  end unless method_defined?(:to_colorf)

  ##
  # to_tone -> Tone
  def to_tone
    return Tone.new(*to_a_na)
  end unless method_defined?(:to_tone)

  ##
  # to_a -> Array<Integer>
  #   [red, green, blue, alpha]
  def to_a
    return [self.red, self.green, self.blue, self.alpha]
  end unless method_defined?(:to_a)

  ##
  # to_h -> Hash<Symbol[:red, :green, :blue, :alpha], Integer>
  def to_h
    return { red: red, green: green, blue: blue, alpha: alpha }
  end unless method_defined?(:to_h)

  ###
  # @return [String]
  ###
  def to_hex_s
    "%06x" % to_rgb24
  end

  ###
  # @return [String]
  ###
  def to_hex_opaque_s
    "%06x" % opaque.to_rgb24
  end

  ###
  # @return [self]
  ###
  def opaque!
    a = self.alpha.to_f / 255.0
    self.red   = self.red   * a
    self.green = self.green * a
    self.blue  = self.blue  * a
    self.alpha = 255
    self
  end

  ###
  # @return [Color]
  ###
  def opaque
    dup.opaque!
  end

  ##
  # ::argb32(Integer pixeli) -> Color
  #   pixeli 0xAARRGGBB
  def self.argb32(pixeli)
    return new((pixeli >> 16) & 0xFF, # red
               (pixeli >>  8) & 0xFF, # green
               (pixeli >>  0) & 0xFF, # blue
               (pixeli >> 24) & 0xFF) # alpha
  end

  ##
  # ::rgb24(Integer pixeli) -> Color
  #   pixeli 0xRRGGBB
  def self.rgb24(pixeli)
    return new((pixeli >> 16) & 0xFF, # red
               (pixeli >> 8)  & 0xFF, # green
               (pixeli >> 0)  & 0xFF) # blue
  end

  ##
  # ::argb16(Integer pixeli) -> Color
  #   pixeli 0xARGB
  def self.argb16(pixeli)
    return new(((pixeli >> 8)  & 0xF) * 0x10, # red
               ((pixeli >> 4)  & 0xF) * 0x10, # green
               ((pixeli >> 0)  & 0xF) * 0x10, # blue
               ((pixeli >> 12) & 0xF) * 0x10) # alpha
  end

  ##
  # ::argb12(Integer pixeli) -> Color
  #   pixeli 0xRGB
  def self.rgb12(pixeli)
    return new(((pixeli >> 8) & 0xF) * 0x10, # red
               ((pixeli >> 4) & 0xF) * 0x10, # green
               ((pixeli >> 0) & 0xF) * 0x10) # blue
  end

  def self.random
    new(rand(0x100), rand(0x100), rand(0x100), 0x100)
  end

  # interfacing for Color/Tone
  alias :to_a_na :to_rgb24_a unless method_defined?(:to_a_na)
  alias :to_a_ng :to_a_na unless method_defined?(:to_a_ng)

end
MACL.register('macl/rgss3-ext/color', '1.4.1')