#
# RGSS3-MACL/lib/rgss-core-ex/sprite.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.1.1
class Sprite

  def move(x, y)
    self.x, self.y = x, y
  end unless method_defined?(:move)

end
