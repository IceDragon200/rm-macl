#
# rm-macl/lib/rm-macl/rgss3-ext/rect/cast.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/core_ext/module'
require 'rm-macl/xpan/surface'
class Rect

  tcast_set(Array)                   { |a| new(a[0], a[1], a[2], a[3]) }
  tcast_set(MACL::Mixin::Surface2)   { |s| new(s.x, s.y, s.width, s.height) }
  tcast_set(self)                    { |s| new(s) }
  tcast_set(:default)                { |d| d.to_rect }

end
MACL.register('macl/rgss3-ext/rect/cast', '1.0.0')