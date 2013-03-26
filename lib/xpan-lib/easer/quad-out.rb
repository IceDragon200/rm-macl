#
# RGSS3-MACL/lib/xpan-lib/easer/quad-out.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Quad::Out < Quad

  register(:quad_out)

  def _ease(t, st, ch, d)
    -ch * (t /= d.to_f) * (t - 2) + st
  end

end
end
end
