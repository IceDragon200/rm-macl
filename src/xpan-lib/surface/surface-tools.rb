#
# src/xpan-lib/surface-tools.rb
# vr 1.00
#
module MACL::Surface::Tool

private

  def self.open_free_surface(klass)
    surf = klass.new
    ostate = surf.freeform
    surf.freeform = true
    yield surf
    surf.freeform = ostate
    return surf
  end

public

  # Surface (2D) - as of v 1.3 2D functions are appended with 0x2 followed
  # by 2 HEX digits
  # 0x2xy
  #
  # Surface3D - all 3d contract functions are appended with 0x3 followed by 3
  # HEX digits
  # 0x3xyz
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
  ID_NULL   = :null
  ID_FLOOR  = :left
  ID_CENTER = :center
  ID_CEIL   = :right
  def self.anchor_to_ids(anchor)
    # Legacy Patch
    anchor =
      case anchor
      when 0  ; 0x200
      when 1  ; 0x213
      when 2  ; 0x223
      when 3  ; 0x233
      when 4  ; 0x212
      when 5  ; 0x222
      when 6  ; 0x232
      when 7  ; 0x211
      when 8  ; 0x221
      when 9  ; 0x231
      when 28 ; 0x202
      when 46 ; 0x220
      when 80 ; 0x201
      when 20 ; 0x203
      when 40 ; 0x210
      when 60 ; 0x230
      else
        anchor
      end

    ids = [ID_NULL, ID_FLOOR, ID_CENTER, ID_CEIL]
    str = nil
    # 3D
    if anchor > 0x200 && anchor < 0x234
      str = "%03x" % anchor
    elsif anchor > 0x3000 && anchor < 0x3334
      str = "%04x" % anchor
    end

    if str
      ary = str.split('')
      ary.shift # drop the 0x2 or 0x3 so your left with x,y[,z]
      return ary.collect do |arg|
        n = arg.to_i
        raise(ArgumentError,
          "invalid numeric value #{n} in #{str} anchor") if n > 3
        ids[n]
      end
    else
      raise(MACL::Mixin::SurfaceAnchorError.mk(anchor))
    end
  end

  def self.id_to_unary(id, strict=false)
    case id
    when ID_NULL
      return 0
    when ID_FLOOR
      return -1
    when ID_CENTER
      return strict ? 0 : 0.5
    when ID_CEIL
      return 1
    end
  end

  def self.anchor_to_unary(anchor, strict=true)
    return anchor_to_ids(anchor).collect do |n|
      id_to_unary(n, strict)
    end
  end

  def self.match?(surface1, surface2)
    return surface1.as_sa == surface2.as_sa
  end

  def self.anchor_surfaces(anchor, src_surface, *surfaces)
    surfaces_rect = area_rect(*surfaces)
    rect = src_surface.align_to(anchor: anchor, surface: surfaces_rect)
    dif_x = rect.x - src_surface.x
    dif_y = rect.y - src_surface.y
    surfaces.each { |surf| surf.x -= dif_x; surf.y -= dif_y }
  end

  #def self.calc_pressure(n, anchor, invert=false)
  #  if anchor == ANCHOR[:horz]
  #    return 0 if n < self.x || n > self.x2
  #    n = n - self.x
  #    n2 = (self.x2 - self.x)
  #    n = n2 - n if invert
  #    n = n / n2.to_f
  #  elsif anchor == ANCHOR[:vert]
  #    return 0 if n < self.y || n > self.y2
  #    n = n - self.y
  #    n2 = (self.y2 - self.y)
  #    n = n2 - n if invert
  #    n = n / n2.to_f
  #  end
  #  return n
  #end

  def self.rotate(surface)
    surface.width, surface.height = surface.height, surface.width
    return surface
  end

  def self.split_surface(surface, cols, rows=1)
    raise(ArgumentError, "cols cannot be #{cols}") if !cols or cols == 0
    raise(ArgumentError, "rows cannot be #{rows}") if !rows or rows == 0

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

    slices_x = slice_x.collect do |x| surface.x + x end
    slices_y = slice_y.collect do |y| surface.y + y end
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

  def self.calc_area_surface(result_klass=Surface, *objs)
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

  def self.area_rect(*objs)
    return calc_area_surface(Rect, *objs)
  end

  def self.fit_in(source, target)
    w, h = source.width, source.height
    if w > h
      scale = target.width.to_f / w
    else
      scale = target.height.to_f / h
    end
    r = source.dup;
    r.width, r.height= (w * scale).to_i, (h * scale).to_i
    return r
  end

  def self.calc_mid_x(surface, n=0)
    surface.x + (surface.width - n) / 2
  end

  def self.calc_mid_y(surface, n=0)
    surface.y + (surface.height - n) / 2
  end

end
