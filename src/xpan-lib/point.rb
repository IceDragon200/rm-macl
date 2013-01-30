#
# src/xpan-lib/point.rb
# vr 1.10
module MACL

  class Point

    include Comparable

    def set(x=0, y=0)
      @x, @y = x.to_i, y.to_i
      return self
    end

    alias :initialize :set

    def ==(obj)
      return (@x == obj.x && @y == obj.y)
    end

    def hash
      return [self.class, @x, @y].hash
    end

    attr_reader :x, :y

    def x=(nx)
      @x = nx.to_i
    end

    def y=(ny)
      @y = ny.to_i
    end

    def pos?(x, y)
      return @x == x && @y == y
    end

    def obj_pos?(obj)
      return pos?(obj.x, obj.y)
    end

    def to_a
      return [@x, @y]
    end

  end

  class Point3D < Point

    alias :set2d :set
    def set(x, y, z)
      @x, @y, @z = x.to_i, y.to_i, z.to_i
      return self
    end

    alias :initialize :set

    alias :eql2d? :==
    alias :pos2d? :pos?
    alias :obj_pos2d? :obj_pos?

    attr_reader :z

    def z=(z)
      @z = z.to_i
    end

    def ==(obj)
      return (@x == obj.x && @y == obj.y && @z == obj.z)
    end

    def pos?(x, y, z)
      return @x == x && @y == y && @z == z
    end

    def obj_pos?(obj)
      return pos?(obj.x, obj.y, obj.z)
    end

    def to_a
      return [@x, @y, @z]
    end

  end

end
