#
# src/xpan-lib/surface/msurface-exfunc.rb
# vr 1.3
#
# CHANGES
#   1.3
#     xpull, xpush, squeeze, release, offset
#       Have been dropped since, their functionality can be completed using
#       #contract and #release with various anchors
#

##
# MSurface
#
# Surface Mixin
#   exfuncs
module MACL::Mixin::Surface

  last_meths = instance_methods

  # by default this is not a 3 Dimensional Surface
  def surface_3d?
    self.kind_of?(MACL::Mixin::Surface3D)
  end

  define_exfunc 'contract' do
    |hash|
    Hash.type_check(hash)

    anchor = hash[:anchor]
    n      = hash[:amount]

    ary = MACL::Surface::Tool.anchor_to_ids(anchor)
    (x, x2), (y, y2), (z, z2) = ary.collect do |id|
      case id
      when MACL::Surface::Tool::ID_NULL   ; [0, 0]
      when MACL::Surface::Tool::ID_FLOOR  ; [0, n]
      when MACL::Surface::Tool::ID_CENTER ; [n, n]
      when MACL::Surface::Tool::ID_CEIL   ; [n, 0]
      else
        raise(ArgumentError)
      end
    end

    a = [x, y, z, x2, y2, z2]

    surf = self.as_surface3d

    surf.freeform = true
    surf.x  += a[0]
    surf.y  += a[1]

    surf.x2 -= a[3]
    surf.y2 -= a[4]

    if surface_3d?
      surf.z  += a[2]
      surf.z2 -= a[5]
    end

    self.x = surf.x
    self.y = surf.y
    self.width = surf.width
    self.height = surf.height

    if surface_3d?
      self.z = surf.z
      self.depth = surf.depth
    end

    return self
  end

  define_exfunc 'expand' do
    |hash|
    Hash.type_check(hash)

    hash = hash.dup
    hash[:amount] = -hash[:amount]

    return contract!(hash)
  end

  define_exfunc 'align_to' do
    |hash|
    Hash.type_check(hash)

    anchor = hash[:anchor]
    r      = hash[:surface] || Graphics.rect

    MACL::Mixin::Surface.type_check(r)

    a = case anchor
    when 0  ; [self.x, self.y]

    when 1  ; [r.x, r.y2 - self.height]
    when 2  ;
      [MACL::Surface::Tool.calc_mid_x(r, self.width), r.y2 - self.height]
    when 3  ; [r.x2 - self.width, r.y2 - self.height]

    when 4  ; [r.x,  MACL::Surface::Tool.calc_mid_y(r, self.height)]
    when 5  ;
      [MACL::Surface::Tool.calc_mid_x(r, self.width),
       MACL::Surface::Tool.calc_mid_y(r, self.height)]
    when 6  ;
      [r.x2 - self.width,
       MACL::Surface::Tool.calc_mid_y(r, self.height)]

    when 7  ; [r.x, r.y]
    when 8  ;
      [MACL::Surface::Tool.calc_mid_x(r, self.width), r.y]
    when 9  ; [r.x2 - self.width, r.y]

    # vertical-mid
    when 28 ;
      [self.x, MACL::Surface::Tool.calc_mid_y(r, self.height)]
    # horizontal-mid
    when 46 ;
      [MACL::Surface::Tool.calc_mid_x(r, self.width), self.y]

    # horizontal-left
    when 40 ; [r.x, self.y]
    # horizontal-right
    when 60 ; [r.x2 - self.width, self.y]

    # vertical-bottom
    when 20 ; [self.x, r.y2 - self.height]
    # vertical-top
    when 80 ; [self.x, r.y]

    else
      raise(SurfaceAnchorError.mk(anchor))
    end

    self.x = a[0]
    self.y = a[1]

    return self
  end

  meths = instance_methods - last_meths
  define_method(:exfuncs) do
    return meths
  end

  module_function :exfuncs

end

# Bang functions only
module MACL::Mixin::SurfaceBang

  include MACL::Mixin::Surface

  # remove none-bang exfuncs
  MACL::Mixin::Surface.exfuncs.each do |sym|
    next if sym.to_s.end_with?(?!) # skip if its a bang function
    undef_method(sym)
  end

end
