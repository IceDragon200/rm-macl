#
# RGSS3-MACL/lib/rgss-core-ex/window.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.1.0
class Window

  def to_a
    return [self.x, self.y, self.width, self.height]
  end unless method_defined?(:to_a)

  def to_rect
    return Rect.new(self.x, self.y, self.width, self.height)
  end unless method_defined?(:to_rect)

end
