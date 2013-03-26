#
# RGSS3-MACL/lib/xpan-lib/easer/back-inout.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Back::InOut < Back

  register(:back_inout)

  def _ease(t, st, ch, d)
    (t /= d/2.0) < 1 ?
      ch / 2.0 * (t * t * (((@s *= (1.525)) + 1) * t - @s)) + st :
      ch / 2.0 * ((t -= 2) * t * (((@s *= (1.525)) + 1) * t + @s) + 2) + st
  end

end
end
end
