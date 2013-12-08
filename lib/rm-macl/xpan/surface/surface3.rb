#
# rm-macl/lib/rm-macl/xpan/surface/surface3.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/core_ext/module'
require 'rm-macl/xpan/surface/surface2'
require 'rm-macl/xpan/surface/msurface3'

module MACL
  module Surface
    class Surface3 < Surface2

      include MACL::Mixin::Surface3

      attr_reader :z, :z2

      def set(*args)
        case args.size
        when 1
          surface = args[0]
          x, y, z, x2, y2, z2 = Convert.Surface3(surface).to_s3a
        when 6
          x, y, z, x2, y2, z2 = *args
        else
          raise ArgumentError,
                "expected 1 or 6 parameters but recieved #{args.size}"
        end
        @x, @y, @z, @x2, @y2, @z2 = x, y, z, x2, y2, z2
        self
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
        @x, @y, @z, @x2, @y2, @z2 = 0, 0, 0, 0, 0, 0; self
      end

      def to_s
        "<#{self.class.name} x: #{@x} y: #{@y} z: #{@z} x2: #{@x2} y2: #{@y2} z2: #{@z2}>"
      end

      tcast_set(Array)                 { |a| new(a[0], a[1], a[2], a[3]) }
      tcast_set(MACL::Mixin::Surface3) { |s| new(s.x, s.y, s.z, s.width, s.height, s.depth) }
      tcast_set(MACL::Size3)           { |s| new(0, 0, 0, s.width, s.height, s.depth) }
      tcast_set(Cube)                  { |s| new(s.x, s.y, s.z, s.width, s.height, s.depth) }
      tcast_set(self)                  { |s| new(s.x, s.y, s.z, s.width, s.height, s.depth) }
      tcast_set(:default)              { |d| d.to_surface2 }

      alias :initialize :set

    end
  end
end
MACL.register('macl/xpan/surface/surface3', '2.1.0')