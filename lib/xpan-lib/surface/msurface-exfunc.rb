#
# RGSS3-MACL/lib/xpan-lib/surface/msurface-exfunc.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.3.1
#
# CHANGES
#   1.3
#     xpull, xpush, squeeze, release, offset
#       Have been dropped since, their functionality can be completed using
#       #contract and #release with various anchors
#
require File.join(File.dirname(__FILE__), 'msurface')

##
# MSurface
#
# Surface Mixin
#   exfuncs
module MACL
module Mixin
module Surface

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
    (x, x2), (y, y2), (z, z2) = ary.map do |id|
      case id
      when MACL::Surface::Tool::ID_NULL   then [0, 0]
      when MACL::Surface::Tool::ID_FLOOR  then [0, n]
      when MACL::Surface::Tool::ID_CENTER then [n, n]
      when MACL::Surface::Tool::ID_CEIL   then [n, 0]
      else
        raise(ArgumentError)
      end
    end

    a = [x, y, z, x2, y2, z2]

    surf = self.to_surface3d

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

    anchor_ids = MACL::Surface::Tool.anchor_to_ids(anchor)

    x = case anchor_ids[0]
    when MACL::Surface::Tool::ID_NULL   ; self.x
    when MACL::Surface::Tool::ID_FLOOR  ; r.x
    when MACL::Surface::Tool::ID_CENTER ; MACL::Surface::Tool.calc_mid_x(r, self.width)
    when MACL::Surface::Tool::ID_CEIL   ; r.x2 - self.width
    end

    y = case anchor_ids[1]
    when MACL::Surface::Tool::ID_NULL   ; self.y
    when MACL::Surface::Tool::ID_FLOOR  ; r.y
    when MACL::Surface::Tool::ID_CENTER ; MACL::Surface::Tool.calc_mid_y(r, self.height)
    when MACL::Surface::Tool::ID_CEIL   ; r.y2 - self.height
    end

    z = case anchor_ids[3]
    when MACL::Surface::Tool::ID_NULL   ; self.z
    when MACL::Surface::Tool::ID_FLOOR  ; r.z
    when MACL::Surface::Tool::ID_CENTER ; MACL::Surface::Tool.calc_mid_z(r, self.depth)
    when MACL::Surface::Tool::ID_CEIL   ; r.z2 - self.depth
    end

    self.x, self.y = x, y
    self.z = z if self.surface_3d?

    return self
  end

  meths = instance_methods - last_meths
  define_method(:exfuncs) do
    return meths
  end

  module_function :exfuncs

end

# Bang functions only
module SurfaceBang

  include MACL::Mixin::Surface

  # remove none-bang exfuncs
  MACL::Mixin::Surface.exfuncs.each do |sym|
    next if sym.to_s.end_with?(?!) # skip if its a bang function
    undef_method(sym)
  end

end
end
end
