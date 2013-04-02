#
# RGSS3-MACL/lib/fallback-lib/color.rb
#   by IceDragon
#   dc 01/04/2013
#   dc 01/04/2013
# vr 1.0.0
module MACL
module Fallback
class Color

  attr_reader :red, :green, :blue, :alpha

  def red=(new_red)
    @red = [[new_red.to_i, 255].min, 0].max
  end

  def green=(new_green)
    @green = [[new_green.to_i, 255].min, 0].max
  end

  def blue=(new_blue)
    @blue = [[new_blue.to_i, 255].min, 0].max
  end

  def alpha=(new_alpha)
    @alpha = [[new_alpha.to_i, 255].min, 0].max
  end

  def set(*args)
    case args.size
    when 1
      arg, = args
      case arg
      when *self.class.color_datatypes
        r, g, b, a = arg.to_a
      when Hash
        r, g, b, a = arg[:red], arg[:green], arg[:blue], arg[:alpha]
      when Array
        r, g, b, a = *arg
      else
        raise(TypeError, "Expected type Color, Hash or Array")
      end
    when 3
      r, g, b = *args; a = 0xFF
    when 4
      r, g, b, a = *args
    else
      raise(ArgumentError,
            "Expected 1, 3 or 4 arguments but recieved #{args.size}")
    end
    self.red, self.green, self.blue, self.alpha = r, g, b, a
  end

  def to_a
    [red, green, blue, alpha]
  end

  def self.color_datatypes
    [Color]
  end

  alias :initialize :set

  private :initialize

end
end
end
