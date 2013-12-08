#
# rm-macl/lib/rm-macl/rgss-core-ex/sprite.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.1.1
require 'rm-macl/macl-core'
class Sprite

  def move(x, y)
    self.x += x
    self.y += y
  end unless method_defined?(:move)

end
MACL.register('macl/rgss3-ext/sprite', '1.2.0')