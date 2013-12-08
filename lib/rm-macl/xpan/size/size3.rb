#
# rm-macl/lib/rm-macl/xpan/size/size3.rb
#
require 'rm-macl/macl-core'
require 'rm-macl/xpan/size/size'
require 'rm-macl/xpan/type-stub'
module MACL
  class Size3 < Size

    float_accessor :width
    float_accessor :height
    float_accessor :depth

    def initialize(w, h, d)
      @width, @height, @depth = w, h, d
    end

    def add!(other)
      s = self.class.tcast(other)
      self.width  += s.width
      self.height += s.height
      self.depth  += s.depth
      return self
    end

    def sub!(other)
      s = self.class.tcast(other)
      self.width  -= s.width
      self.height -= s.height
      self.depth  -= s.depth
      return self
    end

    def mul!(other)
      s = self.class.tcast(other)
      self.width  *= s.width
      self.height *= s.height
      self.depth  *= s.depth
      return self
    end

    def div!(other)
      s = self.class.tcast(other)
      self.width  /= s.width
      self.height /= s.height
      self.depth  /= s.depth
      return self
    end

    def set!(other)
      s = self.class.tcast(other)
      self.width  = s.width
      self.height = s.height
      self.depth  = s.depth
      return self
    end

    def [](index)
      case index
      when 0 then width
      when 1 then height
      when 2 then depth
      else        raise IndexError, index
      end
    end

    def []=(index, n)
      case index
      when 0 then self.width  = n
      when 1 then self.height = n
      when 2 then self.depth = n
      else        raise IndexError, index
      end
    end

    ##
    # to_a -> Array<int> [width, height, depth]
    def to_a
      return width, height, depth
    end

    def rotate!
      self.width, self.height, self.depth = self.height, self.depth, self.width
    end

    def rotate
      dup.rotate!
    end

    tcast_set(Numeric)               { |n| new(n, n, n) }
    tcast_set(Array)                 { |a| new(a[0], a[1], a[2]) }
    tcast_set(self)                  { |s| new(s.width, s.height, s.depth) }
    tcast_set(MACL::Cube)            { |c| new(c.width, c.height, c.depth) }
    tcast_set(MACL::Mixin::Surface3) { |s| new(s.width, s.height, s.depth) }
    tcast_set(MACL::Vector3)         { |s| new(s.x, s.y, s.z) }
    tcast_set(:default)              { |s| s.to_size3 }

    class << self
      public :new
    end

  end
end
MACL.register('macl/xpan/size/size3', '1.3.0')