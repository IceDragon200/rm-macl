##
# MSurface
#
# Surface Mixin
#
module MACL::Mixin::Surface

  extend MACL::Mixin::Archijust

  attr_accessor :freeform

  # it is advised that x2, y2 be overwritten for your special class
  def x2
    self.x + self.width
  end

  def y2
    self.y + self.height
  end

  def x2=(n)
    unless @freeform
      self.x = n - self.width
    else
      self.width = n - self.x
    end
  end

  def y2=(n)
    unless @freeform
      self.y = n - self.height
    else
      self.height = n - self.y
    end
  end

  def cx
    x + width / 2
  end

  def cy
    y + height / 2
  end

  def cx=(x)
    self.x = x - self.width / 2
  end

  def cy=(y)
    self.y = y - self.height / 2
  end

  def hset(hash)
    x, y, x2, y2, w, h = hash.get_values(:x, :y, :x2, :y2, :width, :height)

    self.x, self.y          = x || self.x, y || self.y
    self.x2, self.y2        = x2 || self.x2, y2 || self.y2
    self.width, self.height = w || self.width, h || self.height

    return self
  end

  define_as space_rect: Rect.new(0, 0, 0, 0)

  def clamp_to_space()
    v4 = (viewport || Graphics).rect.as_surface
    r = space_rect
    clx = v4.x + r.x
    clw = v4.x2 - self.width - r.width
    cly = v4.y + r.y
    clh = v4.y2 - self.height - r.height
    self.x, self.y = self.x.clamp(clx, clw), self.y.clamp(cly, clh)
  end

end
