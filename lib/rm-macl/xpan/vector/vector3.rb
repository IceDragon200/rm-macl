#
# rm-macl/lib/rm-macl/xpan/vector/vector3.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/core_ext/module'
require 'rm-macl/xpan/vector/vector'
require 'rm-macl/xpan/type-stub'
module MACL
  class Vector3 < Vector

    def initialize(x, y, z)
      super(3)
      self.x = x
      self.y = y
      self.z = z
    end

    def x
      self[0]
    end

    def y
      self[1]
    end

    def z
      self[2]
    end

    def x=(n)
      self[0] = n
    end

    def y=(n)
      self[1] = n
    end

    def z=(n)
      self[2] = n
    end

    tcast_set(Numeric)               { |n| new(n, n, n) }
    tcast_set(Array)                 { |a| new(a[0], a[1], a[2]) }
    tcast_set(self)                  { |s| new(s.x, s.y, s.z) }
    tcast_set(Rect)                  { |r| new(r.x, r.y, r.z) }
    tcast_set(MACL::Size3)           { |r| new(r.x, r.y, r.z) }
    tcast_set(MACL::Mixin::Surface3) { |s| new(s.x, s.y, s.z) }
    tcast_set(:default)              { |s| s.to_vector3 }

  end
end
MACL.register('macl/xpan/vector/vector3', '2.0.0')