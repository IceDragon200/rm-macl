#
# RGSS3-MACL/lib/xpan-lib/easer/bounce-inout.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Bounce::InOut < Bounce

  register(:bounce_inout)

  def _ease(t, st, ch, d)
    if t < (d / 2.0)
      Bounce::In.ease(t*2.0, 0, ch, d) * 0.5 + st
    else
      Bounce::Out.ease(t*2.0 - d, 0, ch, d) * 0.5 + ch * 0.5 + st
    end
  end

end
end
end
