#-//06/02/2012
#-//06/02/2012
#-inject gen_class_header 'Rect'
class Rect
  def to_a
    return self.x, self.y, self.width, self.height
  end
  def to_va
    return self.x, self.y, self.x+self.width, self.y+self.height
  end
  def to_rect
    Rect.new *to_a
  end
end