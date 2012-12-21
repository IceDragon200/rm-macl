#
# src/xpan-lib/surface/surface.rb
#

##
# Surface
#
class Surface

  include MACL::Mixin::Surface

  def self.rect_to_v4a(rect)
    return rect.as_v4a
  end

  def self.v4a_to_rect(v4a)
    x, y, x2, y2 = *v4a

    w = x2 - x
    h = y2 - y

    return Rect.new(x, y, w, h)
  end

  def self.center(r1, r2)
    return Rect.new(
      r1.x + (r1.width - r2.width) / 2,
      r1.y + (r1.height - r2.height) / 2,
      r2.width, r2.height
    )
  end

  def self.area_rect(*objs)
    mx = objs.min_by(&:x)
    my = objs.min_by(&:y)
    mw = objs.max_by(&:x2)
    mh = objs.max_by(&:y2)
    return Vector4.v4a_to_rect( [mx.x, my.y, mw.x2, mh.y2] )
  end

  def self.fit_in(source, target)
    w, h = source.width, source.height
    if w > h
      scale = target.width.to_f / w
    else
      scale = target.height.to_f / h
    end
    r = source.dup;
    r.width, r.height= (w * scale).to_i, (h * scale).to_i
    return r
  end

  attr_accessor :x, :y, :x2, :y2

  def initialize(x=0, y=0, x2=0, y2=0)
    @x, @y, @x2, @y2 = x, y, x2, y2
  end

  def width
    @x2 - @x
  end

  def height
    @y2 - @y
  end

  def width=(new_width)
    @x2 = @x + new_width
  end

  def height=(new_height)
    @y2 = @y + new_height
  end

  def set(*args)
    case args.size
    when 1
      surface = args[0]

      raise(TypeError, "expected kind of Surface but received #{surface.class}") unless surface.kind_of?(MACL::Mixin::Surface)

      x, y, x2, y2 = surface.to_v4a
    when 4
      x, y, x2, y2 = *args
    else
      raise(ArgumentError, "expected 1 or 4 parameters but recieved #{args.size}")
    end

    @x, @y, @x2, @y2 = x, y, x2, y2
  end

  def empty
    @x, @y, @x2, @y2 = 0, 0, 0, 0
  end

  def to_s
    "<#{self.class.name} x: #{@x} y: #{@y} x2: #{@x2} y2: #{@y2}>"
  end

end
