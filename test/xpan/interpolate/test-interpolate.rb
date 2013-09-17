require File.join(File.dirname(__FILE__), 'common.rb')
ab, bc, cd, abbc, bccd = Array.new(5) { MACL::Vector2I.zero }
MACL::Interpolate.lerp(ab, a, b, t)         # // point between a and b (green)
MACL::Interpolate.lerp(bc, b, c, t)         # // point between b and c (green)
MACL::Interpolate.lerp(cd, c, d, t)         # // point between c and d (green)
MACL::Interpolate.lerp(abbc, ab, bc, t)     # // point between ab and bc (blue)
MACL::Interpolate.lerp(bccd, bc, cd, t)     # // point between bc and cd (blue)
MACL::Interpolate.lerp(dest, abbc, bccd, t) # // point on the bezier-curve (black)