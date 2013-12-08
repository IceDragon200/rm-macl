#
# rm-macl/lib/rm-macl/xpan/size/size2.rb
#
require 'rm-macl/macl-core'
require 'rm-macl/xpan/size/size'
require 'rm-macl/xpan/type-stub'
module MACL
  class Size2 < Size

    float_accessor :width
    float_accessor :height

    def initialize(w, h)
      @width, @height = w, h
    end

    def add!(other)
      s = self.class.tcast(other)
      self.width  += s.width
      self.height += s.height
      return self
    end

    def sub!(other)
      s = self.class.tcast(other)
      self.width  -= s.width
      self.height -= s.height
      return self
    end

    def mul!(other)
      s = self.class.tcast(other)
      self.width  *= s.width
      self.height *= s.height
      return self
    end

    def div!(other)
      s = self.class.tcast(other)
      self.width  /= s.width
      self.height /= s.height
      return self
    end

    def set!(other)
      s = self.class.tcast(other)
      self.width  = s.width
      self.height = s.height
      return self
    end

    def [](index)
      case index
      when 0 then width
      when 1 then height
      else        raise IndexError, index
      end
    end

    def []=(index, n)
      case index
      when 0 then self.width  = n
      when 1 then self.height = n
      else        raise IndexError, index
      end
    end

    ##
    # to_a -> Array<int> [width, height]
    def to_a
      return width, height
    end

    def flip!
      self.height, self.width = self.width, self.height
    end

    def flip
      return dup.flip!
    end

    tcast_set(Numeric)               { |n| new(n, n) }
    tcast_set(Array)                 { |a| new(a[0], a[1]) }
    tcast_set(self)                  { |s| new(s.width, s.height) }
    tcast_set(Rect)                  { |r| new(r.width, r.height) }
    tcast_set(MACL::Mixin::Surface2) { |s| new(s.width, s.height) }
    tcast_set(MACL::Vector2)         { |s| new(s.x, s.y) }
    tcast_set(:default)              { |s| s.to_size2 }

    class << self
      public :new
    end

  end
end
MACL.register('macl/xpan/size/size2', '1.2.0')