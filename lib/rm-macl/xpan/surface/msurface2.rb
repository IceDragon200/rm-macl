#
# rm-macl/lib/rm-macl/xpan/surface/msurface.rb
#   by IceDragon
# CHANGES
#   1.4.1
#     reanchor rewritten slightly using new anchor_* methods
#
#   1.4.0
#     reanchor added
#
#   1.3.0
#     xpull, xpush, squeeze, release, offset
#       Have been dropped since, their functionality can be completed using
#       #contract and #release with various anchors
#
require 'rm-macl/macl-core'
require 'rm-macl/mixin/archijust'
module MACL
  module Mixin
    module Surface2

      extend MACL::Mixin::Archijust

      attr_accessor :freeform

      ##
      # freeform_do
      #   The Surface will enter freeform editing based on the given toggle state
      #   within the block
      #   the original state is restored once the block is completed
      def freeform_do(toggle=true)
        return to_enum(:freeform_do) unless block_given?
        old_freeform = @freeform
        @freeform = toggle
        yield self
        @freeform = old_freeform
        self
      end

      def move(x, y)
        self.x += x
        self.y += y
      end

      def moveto(x, y)
        self.x, self.y = x, y
      end

      # it is advised that x2, y2 be overwritten for your special class
      ##
      # x2
      def x2
        self.x + self.width
      end

      ##
      # y2
      def y2
        self.y + self.height
      end

      ##
      # x2=(Integer n)
      def x2=(n)
        if @freeform
          self.width = n - self.x
        else
          self.x = n - self.width
        end
      end

      ##
      # y2=(Integer n)
      def y2=(n)
        if @freeform
          self.height = n - self.y
        else
          self.y = n - self.height
        end
      end

      ##
      # cx
      def cx
        x + width / 2
      end

      ##
      # cy
      def cy
        y + height / 2
      end

      ##
      # cx=(Integer x)
      def cx=(x)
        self.x = x - self.width / 2
      end

      ##
      # cy=(Integer y)
      def cy=(y)
        self.y = y - self.height / 2
      end

      ##
      # hset(Hash hash)
      def hset(hash)
        x, y, x2, y2, w, h = hash.get_values(:x, :y, :x2, :y2, :width, :height)

        self.x, self.y          = x || self.x, y || self.y
        self.x2, self.y2        = x2 || self.x2, y2 || self.y2
        self.width, self.height = w || self.width, h || self.height

        return self
      end

      def get_by_anchor(anchors)
        [case anchors[0]
        when 0 then nil
        when 1 then self.x
        when 2 then self.cx
        when 3 then self.x2
        end,
        case anchors[1]
        when 0 then nil
        when 1 then self.y
        when 2 then self.cy
        when 3 then self.y2
        end]
      end

      def set_by_anchor(anchors, values)
        case anchors[0]
        when 0 then
        when 1 then self.x  = values[0]
        when 2 then self.cx = values[0]
        when 3 then self.x2 = values[0]
        end
        case anchors[1]
        when 0 then
        when 1 then self.y  = values[1]
        when 2 then self.cy = values[1]
        when 3 then self.y2 = values[1]
        end
        self
      end

      ##
      # anchor_point(anchor) -> Point
      #   Calculates and returns the "Anchor" Point (x, y[, z]) Surface
      def anchor_point_abs_a(anchor)
        return get_by_anchor(MACL::Convert.Anchor(anchor).to_a)
      end

      def anchor_point(anchor)
        x, y, z = anchor_point_abs_a(anchor)
        if surface3?
          return MACL::Vector3I.new(x, y, z)
        else
          return MACL::Vector2I.new(x, y)
        end
      end

      ##
      #   using right hand rule
      def points
        [MACL::Vector2I.new(x2, y),
         MACL::Vector2I.new(x2, y2),
         MACL::Vector2I.new(x, y2),
         MACL::Vector2I.new(x, y)]
      end

      def contains?(nx, ny)
        return (x <= nx && nx < x2) && (y <= ny && ny < y2)
      end

      def intersects?(other, output_surface=nil)
        return false if other.x >= x2
        return false if other.y >= y2
        return false if other.x2 <= x
        return false if other.y2 <= y
        if output_surface
          output_surface.set(
            MACL::Surface::Surface2.new.freeform_do(true) do |s|
              s.x  = [other.x, x].max
              s.y  = [other.y, y].max
              s.x2 = [other.x2, x2].min
              s.y2 = [other.y2, y2].min
            end)
        end
        return true
      end

      def surface2?
        kind_of?(MACL::Mixin::Surface2)
      end

      def surface3?
        kind_of?(MACL::Mixin::Surface3)
      end

      def subsample(*args)
        case args.size
        when 1
          arg,=args
          r = Convert.Surface2(arg)
        when 4
          r = Convert.Surface2(args)
        else
          raise ArgumentError,
                "wrong argument number #{args.size} (expected 1, or 4 arguments)"
        end
        sx, sy, sw, sh = *r
        sw += sx if sx < 0
        sh += sy if sy < 0
        fx = [x+sx, x].max
        fy = [y+sy, y].max
        fw = [width-sx, sw].min
        fh = [height-sy, sh].min
        self.class.new(fx, fy, fw, fh)
      end

      last_meths = instance_methods

      ##
      # contract!(anchor: ANCHOR, amount: Numeric)
      # contract(anchor: ANCHOR, amount: Numeric)
      define_exfunc :contract do |hash|
        Hash.assert_type(hash)

        anchor = hash[:anchor]
        n      = hash[:amount]

        ary = MACL::Convert.Anchor(anchor).to_a
        (x, x2), (y, y2), (z, z2) = ary.map do |id|
          case id
          when 0 then [0, 0]
          when 1 then [0, n]
          when 2 then [n, n]
          when 3 then [n, 0]
          else
            raise(ArgumentError)
          end
        end

        a = [x, y, z, x2, y2, z2]

        surf = self.to_surface3

        surf.freeform = true
        surf.x  += a[0]
        surf.y  += a[1]

        surf.x2 -= a[3]
        surf.y2 -= a[4]

        if surface3?
          surf.z  += a[2]
          surf.z2 -= a[5]
        end

        self.x = surf.x
        self.y = surf.y
        self.width = surf.width
        self.height = surf.height

        if surface3?
          self.z = surf.z
          self.depth = surf.depth
        end

        self
      end

      ##
      # expand!(anchor: ANCHOR, amount: Numeric)
      # expand(anchor: ANCHOR, amount: Numeric)
      define_exfunc :expand do |hash|
        Hash.assert_type(hash)

        hash = hash.dup
        hash[:amount] = -hash[:amount]

        return contract!(hash)
      end

      ##
      # align_to!(anchor: ANCHOR)
      # align_to!(anchor: ANCHOR, surface: Surface)
      # align_to(anchor: ANCHOR)
      # align_to(anchor: ANCHOR, surface: Surface)
      define_exfunc :align_to do |hash|
        Hash.assert_type(hash)

        anchor      = MACL::Convert.Anchor(hash.fetch(:anchor))
        src_surface = MACL::Convert.Rect(hash[:surface] || hash[:rect] || Graphics.rect)
        dst_surface = self
        dst_surface.x = case anchor.x
                        when 0 then dst_surface.x
                        when 1 then src_surface.x
                        when 2 then src_surface.x + (src_surface.width - dst_surface.width) / 2
                        when 3 then src_surface.x2 - dst_surface.width
                        end
        dst_surface.y = case anchor.y
                        when 0 then dst_surface.y
                        when 1 then src_surface.y
                        when 2 then src_surface.y + (src_surface.height - dst_surface.height) / 2
                        when 3 then src_surface.y2 - dst_surface.height
                        end
        if dst_surface.surface3?
          dst_surface.z = case anchor.z
                          when 0 then dst_surface.z
                          when 1 then src_surface.z
                          when 2 then src_surface.z + (src_surface.depth - dst_surface.depth) / 2
                          when 3 then src_surface.z2 - dst_surface.depth
                          end
        end
        self
      end

      define_exfunc :reanchor do |*args|
        case args.size
        when 1 # Hash<ANCHOR org_anchor, ANCHOR new_anchor>
          hsh, = args
          Hash.assert_type(hsh)
          org_anchor = hsh.keys.first
          new_anchor = hsh[org_anchor]
        when 2 # ANCHOR org_anchor, ANCHOR new_anchor
          org_anchor, new_anchor = *args
        else
          raise(ArgumentError,
                "expected 1 or 2 arguments but recieved %d" % args.size)
        end
        set_by_anchor(MACL::Convert.Anchor(new_anchor).to_a, anchor_point_abs_a(org_anchor))
        self
      end

      ##
      # step!(NUMPAD dir, Inetger n)
      define_exfunc :step do |dir, n=1|
        case dir
        when 1 then step!(2, n).step!(4, n) # down-left
        when 3 then step!(2, n).step!(6, n) # down-right
        when 7 then step!(8, n).step!(4, n) # up-left
        when 9 then step!(8, n).step!(6, n) # up-right
        when 2 then self.y += self.height * n # down
        when 4 then self.x -= self.width  * n # left
        when 6 then self.x += self.width  * n # right
        when 8 then self.y -= self.height * n # up
        end
        self
      end

      meths = instance_methods - last_meths
      define_method(:exfuncs) do
        return meths
      end

      module_function :exfuncs

      def to_a
        return x, y, width, height
      end

      # as 2D Surface Attribute Array
      def to_s2a
        return x, y, x2, y2
      end

      # as 3D Surface Attribute Array
      def to_s3a
        return x, y, 0, x2, y2, 0
      end

      def to_h
        return { x: x, y: y, width: width, height: height}
      end

      def to_vhash
        return { x: x, y: y, x2: x2, y2: y2 }
      end

      def to_rect
        Rect.new(x, y, width, height)
      end

      def to_cube
        MACL::Cube.new(x, y, 0, width, height, 0)
      end

      def to_surface2
        MACL::Surface::Surface2.new(x, y, x2, y2)
      end

      def to_surface3
        MACL::Surface::Surface3.new(x, y, 0, x2, y2, 0)
      end

    end

    # Bang functions only
    module Surface2Bang

      include MACL::Mixin::Surface2

      # remove none-bang exfuncs
      MACL::Mixin::Surface2.exfuncs.each do |sym|
        if sym.to_s.end_with?(?!) # skip if its a bang function
          undef_method(sym[0, sym.size - 1]) rescue nil
        end
      end

    end
  end
end
MACL.register('macl/xpan/surface/msurface2', '3.1.0')