#
# rm-macl/lib/rm-macl/xpan/size/size2.rb
#
require 'rm-macl/macl-core'
module MACL
  class Size2 < Size

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

    class << self
      public :new
    end

  end
end
MACL.register('macl/xpan/size/size2', '1.2.0')