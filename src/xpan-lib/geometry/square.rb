#
#
# vr 1.00
require_relative 'rectangle.rb'

module MACL::Geometry

  class Square < Rectangle

    def initialize(x, y, w)
      super(x, y, w, w)
    end

    def width=(n)
      @width = @height = n
    end

    def height=(n)
      @width = @height = n
    end

  end

end
