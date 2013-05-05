#
# RGSS3-MACL/lib/xpan-lib/vector/abstract/vector2.rb
#   by IceDragon
#   dc 04/04/2013
#   dm 04/04/2013
# vr 1.5.1
#
#   Vector2 classes must implement #x, #y, #x= and #y= methods
module MACL
module Abstract
module Vector2

  ##
  # Vector2 methods

  ##
  # magnitude -> Float
  def magnitude
    Math.sqrt(self.x * self.x + self.y * self.y)
  end

  ##
  # magnitude=(Float new_magnitude)
  def magnitude=(new_magnitude)
    rad = radian
    self.x = new_magnitude * Math.cos(rad)
    self.y = new_magnitude * Math.sin(rad)
  end

  ##
  # radian -> Float
  def radian
    Math.atan2(self.y, self.x)
  end

  ##
  # radian=(Float new_radian)
  def radian=(new_radian)
    mag = magnitude
    self.x = mag * Math.cos(new_radian)
    self.y = mag * Math.sin(new_radian)
  end

  def normalize!
    rad = radian
    self.x = Math.cos(rad)
    self.y = Math.sin(rad)
    self
  end

  def normalize
    return dup.normalize!
  end

  def angle
    radian * MACL::Vector::PI180
  end

  def angle=(new_angle)
    self.radian = new_angle / MACL::Vector::PI180
  end

  def polar
    [magnitude, radian]
  end

  def flipflop!
    self.x, self.y = self.y, self.x
    self
  end

  def flipflop
    dup.flipflop!
  end

  def self.included(mod)
    def mod.params
      [:x, :y]
    end
  end

end
end
end
