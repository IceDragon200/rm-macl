#
# rm-macl/lib/rm-macl/xpan/vector/vector2.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/core_ext/module'
require 'rm-macl/xpan/vector/vector'
require 'rm-macl/xpan/type-stub'
module MACL
  class Vector2 < Vector

    def initialize(x, y)
      super(2)
      self.x = x
      self.y = y
    end

    def x
      self[0]
    end

    def y
      self[1]
    end

    def x=(n)
      self[0] = n
    end

    def y=(n)
      self[1] = n
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

    tcast_set(Numeric)               { |n| new(n, n) }
    tcast_set(Array)                 { |a| new(a[0], a[1]) }
    tcast_set(self)                  { |s| new(s.x, s.y) }
    tcast_set(Rect)                  { |r| new(r.x, r.y) }
    tcast_set(MACL::Size2)           { |r| new(r.x, r.y) }
    tcast_set(MACL::Mixin::Surface2) { |s| new(s.x, s.y) }
    tcast_set(:default)              { |s| s.to_vector2 }

  end
end
MACL.register('macl/xpan/vector/vector2', '2.0.0')