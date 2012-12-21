##
# MSurface
#
# Surface Mixin
#
module MACL::Mixin::Surface

  SYM_ARGS = [:x, :y, :width, :height]

  include MACL::Constants
  extend MACL::Mixin::Archijust

  def x2
    self.x + self.width
  end

  def y2
    self.y + self.height
  end

  def x2=(n)
    self.x = n - self.width
  end

  def y2=(n)
    self.y = n - self.height
  end

  def cx
    x + width / 2
  end

  def cy
    y + height / 2
  end

  def cx=(x)
    self.x = x - self.width / 2.0
  end

  def cy=(y)
    self.y = y - self.height / 2.0
  end

  def hset(hash)
    x, y, x2, y2, w, h = hash.get_values(:x, :y, :x2, :y2, :width, :height)

    self.x, self.y          = x || self.x, y || self.y
    self.x2, self.y2        = x2 || self.x2, y2 || self.y2
    self.width, self.height = w || self.width, h || self.height

    return self
  end

  def calc_mid_x(n=0)
    self.x + (self.width-n) / 2
  end

  def calc_mid_y(n=0)
    self.y + (self.height-n) / 2
  end

  def area
    width * height
  end

  def perimeter
    (width * 2) + (height * 2)
  end

  define_as space_rect: Rect.new(0,0,0,0)

  def clamp_to_space()
    v4 = (viewport || Graphics).rect.as_surface
    r = space_rect
    clx = v4.x + r.x
    clw = v4.x2 - self.width - r.width
    cly = v4.y + r.y
    clh = v4.y2 - self.height - r.height
    self.x, self.y = self.x.clamp(clx, clw), self.y.clamp(cly, clh)
  end

  def calc_pressure(n, anchor, invert=false)
    if anchor == ANCHOR[:horz]
      return 0 if n < self.x || n > self.x2
      n = n - self.x
      n2 = (self.x2 - self.x)
      n = n2 - n if invert
      n = n / n2.to_f
    elsif anchor == ANCHOR[:vert]
      return 0 if n < self.y || n > self.y2
      n = n - self.y
      n2 = (self.y2 - self.y)
      n = n2 - n if invert
      n = n / n2.to_f
    end
    return n
  end

  def in_area? ax, ay
    return ax.between?(self.x, self.x2) &&
      ay.between?(self.y, self.y2)
  end

  def intersect? v4
    return in_area?(v4.x, v4.y) || in_area?(v4.width,v4.height)
  end  ##

end
