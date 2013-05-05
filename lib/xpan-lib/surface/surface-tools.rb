#
# RGSS3-MACL/lib/xpan-lib/surface/surface-tools.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 11/04/2013
# vr 1.2.0
module MACL
class Surface
module Tool

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
          anchor2 =  0x200 | (y << 4) | (x << 0)
          anchor3 = 0x3000 | (z << 8) | (y << 4) | (x << 0)
          ANCHOR_CACHE[anchor2] = calc_anchor_ids(anchor2).freeze if z == 0
          ANCHOR_CACHE[anchor3] = calc_anchor_ids(anchor3).freeze
        end
      end
    end
  end

public

  # Surface (2D) - as of v 1.3 2D functions are appended with 0x2 followed
  # by 2 HEX digits
  # 0x2yx
  #
  # Surface3D - all 3d contract functions are appended with 0x3 followed by 3
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
  ID_NULL = 0x0
  ID_MIN  = 0x1
  ID_MID  = 0x2
  ID_MAX  = 0x3

  ANCHOR_CACHE = {}

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

  ##
  # ::anchor_to_ids(ANCHOR anchor)
  def self.anchor_to_ids(anchor)
    # Legacy Patch
    if anchor >= 0 && anchor < 10
      anchor = MACL::Surface::NUMPAD_ANCHOR[anchor]
    elsif anchor > 19 && anchor < 81
      anchor = MACL::Surface::EXTENDED_ANCHOR[anchor]
    end
    ANCHOR_CACHE[anchor]
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
  # ::anchor_to_vec2(ANCHOR anchor, bool strict)
  def self.anchor_to_vec2(anchor, strict=true)
    MACL::Vector2I.new(*anchor_to_signums(anchor, strict)[0, 2])
  end

  ##
  # ::anchor_to_vec3(ANCHOR anchor, bool strict)
  def self.anchor_to_vec3(anchor, strict=true)
    MACL::Vector3I.new(*anchor_to_signums(anchor, strict))
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
  # ::calc_area_surface(*Surface objs) -> Rect
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
    surfaces.each { |surf| surf.x += dif_x; surf.y += dif_y }
  end

  ##
  # flipflop_size(Surface surface)
  #   Swaps the Surface's width and height
  def self.flipflop_size(surface)
    surface.width, surface.height = surface.height, surface.width
    return surface
  end

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

  def self.v4a_to_rect(v4a)
    x, y, x2, y2 = *v4a

    w = x2 - x
    h = y2 - y

    return Rect.new(x, y, w, h)
  end

  def self.center(r1, r2)
    surf_klass = r2.class
    return open_free_surface(surf_klass) do |surf|
      surf.x = r1.x + (r1.width - r2.width) / 2
      surf.y = r1.y + (r1.height - r2.height) / 2
      surf.x2 = surf.x + r2.width
      surf.y2 = surf.y + r2.height
    end
  end

  def self.fit_in(source, target)
    w, h = source.width, source.height
    scale = if w > h then ( target.width.to_f / w)
            else          (target.height.to_f / h)
            end
    r = source.dup;
    r.width, r.height = (w * scale).to_i, (h * scale).to_i
    return r
  end

  def self.calc_mid_x(surface, n=0)
    surface.x + (surface.width - n) / 2
  end

  def self.calc_mid_y(surface, n=0)
    surface.y + (surface.height - n) / 2
  end

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

  def self.tile_objects(objects, rect=Graphics.rect)
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

  ##
  #
  init_anchor_cache

end
end
end
