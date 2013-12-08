#
# rm-macl/lib/rm-macl/rgss-core-ex/rect.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/core_ext/module'
require 'rm-macl/xpan/surface'
class Rect

  ##
  # empty? -> Boolean
  #   is this Rect empty, or its area is 0?
  def empty?
    return (width == 0 or height == 0)
  end unless method_defined?(:empty?)

  ##
  # to_a -> Array<Integer>[x, y, width, height]
  def to_a
    return x, y, width, height
  end unless method_defined?(:to_a)

  ##
  # to_h -> Hash<Symbol[x, y, width, height], Integer>
  def to_h
    return { x: x, y: y, width: width, height: height }
  end unless method_defined?(:to_h)

  ##
  # to_rect -> Rect
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
              "expected type Array or Rect but recieved %s" % obj.class.name)
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

  tcast_set(Array)                   { |a| new(a[0], a[1], a[2], a[3]) }
  tcast_set(MACL::Mixin::Surface2)   { |s| new(s.x, s.y, s.width, s.height) }
  tcast_set(self)                    { |s| new(s) }
  tcast_set(:default)                { |d| d.to_rect }

end
MACL.register('macl/rgss3-ext/rect', '1.2.0')