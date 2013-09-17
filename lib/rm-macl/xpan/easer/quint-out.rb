#
# rm-macl/lib/rm-macl/xpan/easer/quint-out.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Quint::Out < Quint

  register(:quint_out)

  def _ease(t, st, ch, d)
    ch * ((t = t / d.to_f - 1) * t ** 4 + 1) + st
  end

end
end
end
