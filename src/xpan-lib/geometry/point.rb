#
#
# vr 1.00
module MACL::Geometry

  class Point

    class << self
      alias :[] :new
    end

    attr_accessor :x, :y

    def initialize(x=0, y=0)
      @x, @y = x, y
    end

    def to_a
      return [@x, @y]
    end

  end

end
