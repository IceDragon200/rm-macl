#
# rm-macl/lib/rm-macl/xpan/easer/quint-inout.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Quint::InOut < Quint

  register(:quint_inout)

  def _ease(t, st, ch, d)
    if (t /= d / 2.0) < 1
      ch / 2.0 * t ** 5 + st
    else
      ch / 2.0 * ((t -= 2) * t ** 4 + 2) + st
    end
  end

end
end
end
