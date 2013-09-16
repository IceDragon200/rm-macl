#
# RGSS3-MACL/lib/xpan-lib/easer/circ-out.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Circ::Out < Circ

  register(:circ_out)

  def _ease(t, st, ch, d)
    t = t/d - 1 ; ch * Math.sqrt(1 - t * t) + st rescue st
  end

end
end
end
