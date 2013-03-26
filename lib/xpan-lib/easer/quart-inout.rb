#
# RGSS3-MACL/lib/xpan-lib/easer/quart-inout.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Quart::InOut < Quart

  register(:quart_inout)

  def _ease(t, st, ch, d)
    (t /= d / 2.0) < 1 ?
      ch / 2.0 * t ** 4 + st :
      -ch / 2.0 * ((t -= 2) * t ** 3 - 2) + st
  end

end
end
end
