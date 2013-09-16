#
# RGSS3-MACL/lib/xpan-lib/easer/bounce-in.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Bounce::In < Bounce

  register(:bounce_in)

  def _ease(t, st, ch, d)
    ch - MACL::Easer::Bounce::Out.ease(d-t, 0, ch, d) + st
  end

end
end
end
