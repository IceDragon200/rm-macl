#
# rm-macl/lib/rm-macl/rgss3-ext/color/cast.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/core_ext/module'
class Color

  tcast_set(Numeric)                 { |n| new(n, n, n, 255) }
  tcast_set(Array)                   { |a| new(a[0], a[1], a[2], a[3] || 255) }
  tcast_set(Tone)                    { |t| new(t.red, t.green, t.blue) }
  tcast_set(self)                    { |s| new(s) }
  tcast_set(:default)                { |s| s.to_color }

end
MACL.register('macl/rgss3-ext/color/cast', '1.0.0')