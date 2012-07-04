# ╒╕ ♥                                                                 Rect ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Rect
  def / n
    self.class.new(self.x/n,self.y/n,self.width/n,self.height/n)
  end
  def * n
    self.class.new(self.x*n,self.y*n,self.width*n,self.height*n)
  end
  def to_a
    return self.x, self.y, self.width, self.height
  end
  def to_va
    return self.x, self.y, self.x+self.width, self.y+self.height
  end
  def to_rect
    Rect.new *to_a
  end
  def empty?
    self.width == 0 and self.height == 0
  end
end
# ╒╕ ♥                                                              Vector4 ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Vector4 < Rect
  def rwidth
    self.width - self.x
  end
  def rheight
    self.height - self.y
  end
  def vwidth
    self.width
  end
  def vheight
    self.height
  end
  def self.v4a_to_rect v4a
    return Rect.new v4a[0], v4a[1], v4a[2]-v4a[0], v4a[3]-v4a[1]
  end
end