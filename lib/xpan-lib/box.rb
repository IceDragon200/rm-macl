#
# RGSS3-MACL/lib/xpan-lib/box.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.1.1
require File.join(File.dirname(__FILE__), 'archijust')

module MACL

  class Box2

    extend MACL::Mixin::Archijust

    float_accessor :width, :height
    multi_setter :set, :width, :height
    alias :initialize :set

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

  end

  class Box3

    extend MACL::Mixin::Archijust

    float_accessor :width, :height, :depth
    multi_setter :set, :width, :height, :depth
    alias :initialize :set

    def to_a
      return [@width, @height, @depth]
    end

    def rescale!(new_scale)
      @width *= new_scale
      @height *= new_scale
      @depth *= new_scale
      return self
    end

    def rescale(new_scale)
      return dup.rescale!(new_scale)
    end

    def rotate!
      @width, @height, @depth = @height, @depth, @width
    end

    def rotate
      return dup.rotate!
    end

    # interfacing for Box2
    def flip!
      @height, @width = @width, @height
    end

    def flip
      return dup.flip!
    end

  end

end
