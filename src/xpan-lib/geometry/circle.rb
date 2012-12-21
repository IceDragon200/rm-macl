#
#
# vr 1.00

require_relative 'oval.rb'

module MACL::Geometry

  class Circle < Oval

    attr_reader :radius

    def initialize( x=0, y=0, radius=0 )
      super( x, y, 0, 0 )
      self.radius = radius
    end

    def diameter
      @radius * 2
    end

    def radius=(n)
      self.radius_x = self.radius_y = @radius = n
    end

    def set(*args)
      args.push(args[2]) if args.size == 3
      super(*args)
    end

  end

end
