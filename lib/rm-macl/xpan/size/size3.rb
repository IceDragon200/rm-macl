#
# rm-macl/lib/rm-macl/xpan/size/size3.rb
#
require 'rm-macl/macl-core'
module MACL
  class Size3 < Size

    extend MACL::Mixin::Archijust

    float_accessor :width, :height, :depth
    multi_setter :set, :width, :height, :depth
    alias :initialize :set

    ##
    # to_a -> Array<int> [width, height, depth]
    def to_a
      [@width, @height, @depth]
    end

    def rescale!(new_scale)
      @width  *= new_scale
      @height *= new_scale
      @depth  *= new_scale
      return self
    end

    def rescale(new_scale)
      dup.rescale!(new_scale)
    end

    def rotate!
      @width, @height, @depth = @height, @depth, @width
    end

    def rotate
      dup.rotate!
    end

    # interfacing for Box2
    def flip!
      @height, @width = @width, @height
    end

    def flip
      dup.flip!
    end

    class << self
      public :new
    end

  end
end
MACL.register('macl/xpan/size/size3', '1.2.0')