#
# RGSS3-MACL/lib/xpan-lib/surface/surface_to.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.1.0
require File.join(File.dirname(__FILE__), 'surface')
require File.join(File.dirname(__FILE__), 'surface3d')

module MACL
module Mixin
module Surface

  def to_ary
    return self.x, self.y, self.width, self.height
  end

  # as 2D Surface Attribute Array
  def to_sa
    return self.x, self.y, self.x2, self.y2
  end

  # as 3D Surface Attribute Array
  def to_s3a
    return self.x, self.y, 0, self.x2, self.y2, 0
  end

  def to_h
    return { x: self.x, y: self.y, width: self.width, height: self.height}
  end

  def to_vhash
    return { x: self.x, y: self.y, x2: self.x2, y2: self.y2 }
  end

  def to_rect
    Rect.new(self.x, self.y, self.width, self.height)
  end

  def to_surface
    MACL::Surface.new(self.x, self.y, self.x2, self.y2)
  end

  def to_surface3d
    MACL::Surface3D.new(self.x, self.y, 0, self.x2, self.y2, 0)
  end

end
end
end
