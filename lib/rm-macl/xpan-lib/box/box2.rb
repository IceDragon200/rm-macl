#
# RGSS3-MACL/lib/xpan-lib/box/box2.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 04/04/2013
# vr 1.1.2
module MACL
  class Box2 < Box

    extend MACL::Mixin::Archijust

    float_accessor :width, :height
    multi_setter :set, :width, :height

    ##
    # to_a -> Array<int> [width, height]
    def to_a
      return [@width, @height]
    end

    def rescale!(new_scale)
      @width *= new_scale
      @height *= new_scale
      return self
    end

    def rescale(new_scale)
      return dup.rescale!(new_scale)
    end

    def flip!
      @height, @width = @width, @height
    end

    def flip
      return dup.flip!
    end

    alias :initialize :set

  end
end
