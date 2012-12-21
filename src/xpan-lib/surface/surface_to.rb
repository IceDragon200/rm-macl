#
# src/xpan-lib/surface/surface_to.rb
#
module MACL::Mixin::Surface

  def as_ary
    return self.x, self.y, self.width, self.height
  end

  def as_v4a
    return self.x, self.y, self.x2, self.y2
  end

  def as_hash
    return { x: self.x, y: self.y, width: self.width, height: self.height}
  end

  def as_vhash
    return { x: self.x, y: self.y, x2: self.x2, y2: self.y2}
  end

  def as_vector4
    Vector4.new *to_v4a
  end

  def as_rect
    Rect.new(self.x, self.y, self.width, self.height)
  end

  def as_surface
    Surface.new(self.x, self.y, self.x2, self.y2)
  end

end
