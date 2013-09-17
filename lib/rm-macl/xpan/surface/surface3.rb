#
# rm-macl/lib/rm-macl/xpan/surface/surface3.rb
#
require 'rm-macl/macl-core'
require 'rm-macl/mixin/archijust'
require 'rm-macl/xpan/surface/msurface3'
require 'rm-macl/xpan/surface/surface'

module MACL
  class Surface3 < MACL::Surface

    attr_reader :z, :z2

    def set(*args)
      case args.size
      when 1
        surface = args[0]

        MACL::Mixin::Surface3.type_check(surface)

        x, y, z, x2, y2, z2 = surface.to_s3a
      when 6
        x, y, z, x2, y2, z2 = *args
      else
        raise(ArgumentError, "expected 1 or 6 parameters but recieved #{args.size}")
      end
      @x, @y, @z, @x2, @y2, @z2 = x, y, z, x2, y2, z2
    end

    def z=(new_z)
      unless @freeform
        @z2 = new_z + depth
      end
      @z = new_z
    end

    def z2=(new_z2)
      unless @freeform
        @z = new_z2 - depth
      end
      @z2 = new_z2
    end

    def depth
      @z2 - @z
    end

    def depth=(new_depth)
      @z2 = @z + new_depth
    end

    def empty
      @x, @y, @z, @x2, @y2, @z2 = 0, 0, 0, 0, 0, 0
    end

    def to_s
      "<#{self.class.name} x: #{@x} y: #{@y} z: #{@z} x2: #{@x2} y2: #{@y2}> z2: #{@z2}"
    end

    alias :initialize :set

  end
end
MACL.register('macl/xpan/surface/surface3', '1.2.0')