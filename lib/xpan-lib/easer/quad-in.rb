#
# RGSS3-MACL/lib/xpan-lib/easer/quad-in.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Quad::In < Quad

  register(:quad_in)

  def _ease(t, st, ch, d)
    ch * (t /= d.to_f) * t + st
  end

end
end
end
