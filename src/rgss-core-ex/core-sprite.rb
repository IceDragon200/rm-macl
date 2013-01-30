#
# src/rgss-core-ex/core-sprite.rb
# vr 1.11
class Sprite

  include MACL::Mixin::Surface

  def move(x, y)
    self.x, self.y = x, y
  end

end
