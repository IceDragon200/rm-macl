#
# rm-macl/lib/rm-macl/xpan/surface/surface.rb
#
require 'rm-macl/macl-core'
require 'rm-macl/xpan/surface/msurface'

module MACL
  class Surface

    include MACL::Mixin::Surface

    attr_reader :x, :y, :x2, :y2
    # when you change x, y, x2, y2
    # if freeform is enabled it affects width, height
    # otherwise, the width, height will be locked, and the opposite value
    # will be adjusted to denote the the change
    #   default: false

    def initialize(*args)
      set(*args)
      @freeform = false
    end

    def x=(new_x)
      unless @freeform
        @x2 = new_x + width
      end
      @x = new_x
    end

    def y=(new_y)
      unless @freeform
        @y2 = new_y + height
      end
      @y = new_y
    end

    def x2=(new_x2)
      unless @freeform
        @x = new_x2 - width
      end
      @x2 = new_x2
    end

    def y2=(new_y2)
      unless @freeform
        @y = new_y2 - height
      end
      @y2 = new_y2
    end

    def width
      @x2 - @x
    end

    def height
      @y2 - @y
    end

    def width=(new_width)
      @x2 = @x + new_width
    end

    def height=(new_height)
      @y2 = @y + new_height
    end

    def set(*args)
      case args.size
      when 1
        surface = args[0]

        MACL::Mixin::Surface.assert_type(surface)

        x, y, x2, y2 = surface.to_sa
      when 4
        x, y, x2, y2 = *args
      else
        raise(ArgumentError, "expected 1 or 4 parameters but recieved #{args.size}")
      end

      @x, @y, @x2, @y2 = x, y, x2, y2
    end

    def empty
      @x, @y, @x2, @y2 = 0, 0, 0, 0
    end

    def to_s
      "<#{self.class.name} x: #{@x} y: #{@y} x2: #{@x2} y2: #{@y2}>"
    end

  end
end
MACL.register('macl/xpan/surface/surface', '1.2.0')