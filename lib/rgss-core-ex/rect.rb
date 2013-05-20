#
# RGSS3-MACL/lib/rgss-core-ex/rect.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.1.0
class Rect

  ##
  # empty?
  def empty?
    return (width == 0 or height == 0)
  end unless method_defined?(:empty?)

  ##
  # to_a
  def to_a
    return [x, y, width, height]
  end unless method_defined?(:to_a)

  ##
  # to_h
  def to_h
    return { x: x, y: y, width: width, height: height }
  end unless method_defined?(:to_h)

  ##
  # to_rect
  def to_rect
    return Rect.new(x, y, width, height)
  end unless method_defined?(:to_rect)

class << self

  ##
  # ::cast(Object* obj) -> Rect
  def cast(obj)
    case obj
    when Rect
      obj.dup
    when Array
      if obj.size == 4
        Rect.new(*obj)
      else
        raise(ArgumentError,
              "expected Array of size 4 but recieved %d" % obj.size)
      end
    else
      raise(TypeError,
            "expected type Array of Rect but recieved %s" % obj.class.name)
    end
  end unless method_defined?(:cast)

  ##
  # ::cast(Object* obj) -> Rect
  alias :rect_cast :cast
  def cast(obj)
    if obj.respond_to?(:to_rect)
      return obj.to_rect
    else
      rect_cast(obj)
    end
  end

end
end
