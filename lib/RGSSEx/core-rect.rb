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
  def area
    self.width*self.height
  end
  def empty?
    self.width == 0 and self.height == 0
  end
end