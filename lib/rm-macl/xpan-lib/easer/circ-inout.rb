#
# RGSS3-MACL/lib/xpan-lib/easer/circ-inout.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Circ::InOut < Circ

  register(:circ_inout)

  def _ease(t, st, ch, d)
    (t /= d / 2.0) < 1 ?
     -ch / 2 * (Math.sqrt(1 - t * t) - 1) + st :
      ch / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + st rescue st
  end

end
end
end
