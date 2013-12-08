#
# rm-macl/lib/rm-macl/rgss-core-ex/window.rb
#   by IceDragon
require 'rm-macl/macl-core'
class Window

  def to_a
    return [self.x, self.y, self.width, self.height]
  end unless method_defined?(:to_a)

  def to_rect
    return Rect.new(self.x, self.y, self.width, self.height)
  end unless method_defined?(:to_rect)

end
MACL.register('macl/rgss3-ext/window', '1.1.0')