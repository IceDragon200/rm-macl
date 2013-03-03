#
# RGSS3-MACL/lib/rgss-core-ex/rect.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.1.0
class Rect

  def empty?
    return (self.width == 0 or self.height == 0)
  end unless method_defined?(:empty?)

  def to_a
    return [self.x, self.y, self.width, self.height]
  end unless method_defined?(:to_a)

  def to_h
    return { x: self.x, y: self.y, width: self.width, height: self.height }
  end unless method_defined?(:to_h)

  def to_rect
    return Rect.new(*to_a)
  end unless method_defined?(:to_rect)

end
