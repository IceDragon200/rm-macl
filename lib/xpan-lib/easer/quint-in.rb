#
# RGSS3-MACL/lib/xpan-lib/easer/quint-in.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Quint::In < Quint

  register(:quint_in)

  def _ease(t, st, ch, d)
    ch * (t /= d.to_f) * t ** 4 + st
  end

end
end
end
