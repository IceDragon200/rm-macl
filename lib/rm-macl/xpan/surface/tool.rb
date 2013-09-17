#
# rm-macl/lib/rm-macl/xpan/surface/tool.rb
#
require 'rm-macl/macl-core'
module MACL
  class Surface
    module Tool

      ##
      # Anchor IDS
      ID_NULL = 0x0 # 0  (disabled anchor point)
      ID_MIN  = 0x1 # -1 (negative anchor point)
      ID_MID  = 0x2 # 0 or 0.5 (depends on the requirement)
      ID_MAX  = 0x3 # +1 (positive anchor point)

      ##
      # Hash<ANCHOR, ID> ANCHOR_CACHE
      ANCHOR_CACHE = {}

      ##
      # Hash<ANCHOR, VectorI> ANCHOR_CACHE
      ANCHOR_VECTOR = {}

    private

      ##
      # ::open_free_surface(Class<subclassof MACL::Mixin::Surface> klass)
      def self.open_free_surface(klass)
        surf = klass.new
        ostate = surf.freeform
        surf.freeform = true
        yield surf
        surf.freeform = ostate
        return surf
      end

      ##
      # ::init_anchor_cache
      def self.init_anchor_cache
        for z in 0..3
          for y in 0..3
            for x in 0..3
              if z == 0
                anchor2 =  0x200 | (y << 4) | (x << 0)
                ANCHOR_CACHE[anchor2] = calc_anchor_ids(anchor2).freeze
                ANCHOR_VECTOR[anchor2] = MACL::Vector2I.new(*anchor_to_signums(anchor2)).freeze
              end
              anchor3 = 0x3000 | (z << 8) | (y << 4) | (x << 0)
              ANCHOR_CACHE[anchor3] = calc_anchor_ids(anchor3).freeze
              ANCHOR_VECTOR[anchor3] = MACL::Vector3I.new(*anchor_to_signums(anchor3)).freeze
            end
          end
        end
      end

    public

      # Surface (2D) - as of v 1.3 2D functions are appended with 0x2 followed
      # by 2 HEX digits
      # 0x2yx
      #
      # Surface3 - all 3d contract functions are appended with 0x3 followed by 3
      # HEX digits
      # 0x3zyx
      #    ^
      #   _Z___
      #  |\  2 \
      #  |1\____\
      #  \ | 0  |
      #< X\|____|
      #      Y
      #     \/
      #
      #   n - enum[    0   ,   1,   2,    3  ]
      #   x - enum[disabled, left, mid, right]
      #   y - enum[disabled, top, mid, bottom]
      #   z - enum[disabled, floor, mid, ceil]

      ##
      # ::calc_anchor_ids(ANCHOR anchor)
      def self.calc_anchor_ids(anchor)
        # is this a 2D Anchor?
        if (anchor >> 8) == 2
          [(anchor >> 0) & 0xF, (anchor >> 4) & 0xF]
        # is this a 3D Anchor?
        elsif (anchor >> 12) == 3
          [(anchor >> 0) & 0xF, (anchor >> 4) & 0xF, (anchor >> 8) & 0xF]
        else
          raise(MACL::Mixin::SurfaceAnchorError.mk(anchor))
        end
      end

      ## added in 1.3.0
      # ::obj_to_anchor(anchor)
      def self.obj_to_anchor(anchor)
        if anchor.is_a?(MACL::Vector)
          case anchor
          when MACL::Abstract::Vector2
            anchor =  0x200 | (anchor.y.signum << 4) | (anchor.x.signum  << 0)
          when MACL::Abstract::Vector3
            anchor = 0x3000 | (anchor.z.signum << 8) | (anchor.y.signum << 4) | (anchor.x.signum << 0)
          else
            raise(TypeError, "cannot convert %s to ANCHOR" % anchor.class.name)
          end
        elsif anchor.is_a?(Symbol)
          ### replace this later
          case anchor
          when :nw then anchor = 0x211 # top-left
          when :n  then anchor = 0x212 # top-center
          when :ne then anchor = 0x213 # top-right
          when :sw then anchor = 0x231 # bottom-left
          when :s  then anchor = 0x232 # bottom-center
          when :se then anchor = 0x233 # bottom-right
          when :w  then anchor = 0x221 # right
          when :e  then anchor = 0x223 # left
          else          raise(ArgumentError, "invalid anchor symbols %s" % anchor)
          end
        else
          # Legacy Patch
          if anchor >= 0 && anchor < 10
            anchor = MACL::Surface::NUMPAD_ANCHOR[anchor]
          elsif anchor > 19 && anchor < 81
            anchor = MACL::Surface::EXTENDED_ANCHOR[anchor]
          end
        end
        return anchor
      end

      ##
      # ::anchor_to_ids(ANCHOR anchor)
      def self.anchor_to_ids(anchor)
        ANCHOR_CACHE[obj_to_anchor(anchor)]
      end

      ##
      # ::anchor_to_vector(ANCHOR anchor)
      def self.anchor_to_vector(anchor)
        ANCHOR_VECTOR[obj_to_anchor(anchor)]
      end

      ##
      # ::id_to_signum(ID id, bool strict)
      def self.id_to_signum(id, strict=false)
        case id
        when ID_NULL then return 0
        when ID_MIN  then return -1
        when ID_MID  then return strict ? 0 : 0.5
        when ID_MAX  then return 1
        end
      end

      ##
      # ::anchor_to_signums(ANCHOR anchor, bool strict)
      def self.anchor_to_signums(anchor, strict=true)
        return anchor_to_ids(anchor).map { |n| id_to_signum(n, strict) }
      end

      ##
      # ::anchor_to_v2f(ANCHOR anchor, bool strict)
      def self.anchor_to_v2f(anchor, strict=true)
        MACL::Vector2F.new(*anchor_to_signums(anchor, strict)[0, 2])
      end

      ##
      # ::anchor_to_v3f(ANCHOR anchor, bool strict)
      def self.anchor_to_v3f(anchor, strict=true)
        MACL::Vector3F.new(*anchor_to_signums(anchor, strict))
      end

      ##
      # ::match?()
      def self.match?(surface1, surface2)
        surface1.to_sa == surface2.to_sa
      end

      ##
      # ::calc_area_surface(Class result_klass, *Surface objs) -> new result_klass
      def self.calc_area_surface(result_klass, *objs)
        mx = objs.min_by(&:x)
        my = objs.min_by(&:y)
        mw = objs.max_by(&:x2)
        mh = objs.max_by(&:y2)
        return open_free_surface(result_klass) do |surf|
          surf.x = mx.x
          surf.y = my.y
          surf.x2 = mw.x2
          surf.y2 = mh.y2
        end
      end

      ##
      # ::area_rect(*Surface objs) -> Rect
      def self.area_rect(*objs)
        return calc_area_surface(Rect, *objs)
      end

      ##
      # ::anchor_surfaces(ANCHOR anchor, Surface src_surface, *Surface surfaces)
      def self.anchor_surfaces(*args)
        case args.size
        when 1
          arg, = args
          anchor, src_surface, surfaces = arg[:anchor],
                                          arg[:src_surface],
                                          arg[:surfaces]
        else
          anchor = args.shift
          src_surface = args.shift
          surfaces = args
        end
        surfaces_rect = area_rect(*surfaces)
        aligned_rect = surfaces_rect.align_to(anchor: anchor, surface: src_surface)
        dif_x = aligned_rect.x - surfaces_rect.x
        dif_y = aligned_rect.y - surfaces_rect.y
        surfaces.each do |surf|
          surf.freeform_do(false) do |s|
            s.x += dif_x
            s.y += dif_y
          end
        end
        return surfaces
      end

      ##
      # ::flipflop_size(Surface surface)
      #   Swaps the Surface's width and height
      def self.flipflop_size(surface)
        surface.width, surface.height = surface.height, surface.width
        return surface
      end

      ##
      # ::split_surface(Surface surface, Integer cols, Integer rows)
      def self.split_surface(surface, cols=1, rows=1)
        raise(ArgumentError, "cols cannot be #{cols}") if !cols or cols <= 0
        raise(ArgumentError, "rows cannot be #{rows}") if !rows or rows <= 0

        surf_klass = surface.class

        result = []

        w = surface.width / cols
        h = surface.height / rows

        for y in 0...rows
          for x in 0...cols

            resurf = open_free_surface(surf_klass) do |surf|
              surf.freeform = false
              surf.x = surface.x + x * w
              surf.y = surface.y + y * h
              surf.width = w
              surf.height = h
            end

            result.push(resurf)
          end
        end

        return result
      end

      ##
      # ::split_surface(Surface surface, Array<Integer> slice_x, Array<Integer> slice_y)
      def self.slice_surface(surface, slice_x=[], slice_y=[])
        surf_klass = surface.class

        slices_x = slice_x.map do |x| surface.x + x end
        slices_y = slice_y.map do |y| surface.y + y end
        slices_x.push(surface.x2)
        slices_y.push(surface.y2)

        slices_x.sort!
        slices_y.sort!

        result = []

        last_y = surface.y
        for sy in slices_y
          last_x = surface.x
          for sx in slices_x
            result.push(open_free_surface(surf_klass) do |surf|
                          surf.x  = last_x
                          surf.y  = last_y
                          surf.x2 = sx
                          surf.y2 = sy
                        end)
            last_x = sx
          end
          last_y = sy
        end

        return result
      end

      ##
      # ::v4a_to_rect(Array<Integer>[x, y, x2, y2] v4a)
      def self.v4a_to_rect(v4a)
        x, y, x2, y2 = *v4a

        w = x2 - x
        h = y2 - y

        return Rect.new(x, y, w, h)
      end

      ##
      # ::center(Surface r1, Surface r2)
      #   Creates a new surface from the result of centering r2 within r1
      def self.center(r1, r2)
        surf_klass = r2.class
        return open_free_surface(surf_klass) do |surf|
          surf.x = r1.x + (r1.width - r2.width) / 2
          surf.y = r1.y + (r1.height - r2.height) / 2
          surf.x2 = surf.x + r2.width
          surf.y2 = surf.y + r2.height
        end
      end

      ##
      # ::fit_in(Surface source, Surface target)
      #   Rescales the surface to "fit" inside the target
      def self.fit_in(source, target)
        w, h = source.width, source.height
        scale = if w > h then ( target.width.to_f / w)
                else          (target.height.to_f / h)
                end
        r = source.dup;
        r.freeform_do(false) do
          r.width, r.height = (w * scale).to_i, (h * scale).to_i
        end
        return r
      end

      ##
      # ::calc_mid_x(Surface surface, Integer n)
      def self.calc_mid_x(surface, n=0)
        surface.x + (surface.width - n) / 2
      end

      ##
      # ::calc_mid_y(Surface surface, Integer n)
      def self.calc_mid_y(surface, n=0)
        surface.y + (surface.height - n) / 2
      end

      ##
      # ::calc_mid_z(Surface surface, Integer n)
      def self.calc_mid_z(surface, n=0)
        surface.z + (surface.depth - n) / 2
      end

      ## initial 1.1.0
      # ::bound_surface_to(Surface dst, Surface src)
      #   Tries to keep the (dst) Surface withing the bounds of the (src) Surface
      def self.bound_surface_to(dst, src)
        dst.freeform_do(false) do
          if dst.width < src.width
            dst.x = src.x if dst.x < src.x
            dst.x2 = src.x2 if dst.x2 > src.x2
          end
          if dst.height < src.height
            dst.y = src.y if dst.y < src.y
            dst.y2 = src.y2 if dst.y2 > src.y2
          end
        end
      end

      ##
      # ::tile_surfaces(Array<Surface> objects)
      # ::tile_surfaces(Array<Surface> objects, Surface rect)
      #   Attempts to tile the elements of (objects) within the (rect)
      #   Not very useful for serious Tiling, mostly done for debugging
      def self.tile_surfaces(objects, rect=Graphics.rect)
        surf = Surface.new(0, 0, 0, 0)
        surf.freeform = true

        largest_h = 0
        objects.each_with_index do |obj, i|

          r = obj.to_rect

          largest_h = r.height if largest_h < r.height

          if((surf.x2 + r.width) > rect.x2)
            surf.x2 = 0
            surf.y2 += largest_h
            largest_h = 0
          end

          obj.x = surf.x2
          obj.y = surf.y2

          r = obj.to_rect

          surf.x2 = r.x2 if surf.x2 < r.x2
          #surf.y2 = r.y2 if surf.y2 < r.y2
        end

        return surf.to_rect
      end

      ## initial 1.3.1
      # ::squarify(Surface surface)
      def self.squarify(surface)
        open_free_surface(surface.class) do |surf|
          surf.x = surface.x
          surf.y = surface.y
          surf.width = surf.height = [surface.width, surface.height].min
        end
      end

      ## initial 1.3.2
      # ::surface_vec_clamp(Surface surf, Vector* vec)
      #   Clamps the given Vector (vec) within the provided the Surface (surf)
      def self.surface_vec_clamp(surf, vec)
        vec.x = vec.x.clamp(surf.x, surf.x2)
        vec.y = vec.y.clamp(surf.y, surf.y2)
        if surf.surface3? && vec.size == 3
          vec.z = vec.z.clamp(surf.z, surf.z2)
        end
      end
      ##
      # Setup the Anchor Cache (Anchor IDS and Vector)
      init_anchor_cache

    end
  end
end
MACL.register('macl/xpan/surface/tool', '1.4.0')