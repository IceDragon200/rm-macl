#
#
# vr 1.0

require_relative 'path'

module MACL::Geometry

  class Angle < Path

    attr_accessor :parent_index

    def initialize(p1, p2, p3)
      super(p1, p2, p3)
      @parent_index = 1
    end

    def parent_point
      @points[@parent_point]
    end

    def angle
    end

    def vertex
    end

  end

end
