#
# rm-macl/lib/rm-macl/xpan/vector/vector4.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/core_ext/module'
require 'rm-macl/xpan/vector/vector'
require 'rm-macl/xpan/type-stub'
module MACL
  class Vector4 < Vector

    def initialize(x, y, z, w)
      super(4)
      self.x = x
      self.y = y
      self.z = z
      self.w = w
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

    def w
      self[3]
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

    def w=(n)
      self[3] = n
    end

    tcast_set(Numeric)               { |n| new(n, n, n, n) }
    tcast_set(Array)                 { |a| new(a[0], a[1], a[2], a[3]) }
    tcast_set(self)                  { |s| new(s.x, s.y, s.z, s.w) }
    tcast_set(:default)              { |s| s.to_vector4 }

  end
end
MACL.register('macl/xpan/vector/vector4', '2.0.0')