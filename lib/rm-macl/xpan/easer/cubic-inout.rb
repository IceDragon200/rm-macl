#
# rm-macl/lib/rm-macl/xpan/easer/cubic-inout.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Cubic::InOut < Cubic

  register(:cubic_inout)

  def _ease(t, st, ch, d)
    (t /= d / 2.0) < 1 ?
      ch / 2.0 * t * t * t + st :
      ch / 2.0 * ((t -= 2) * t * t + 2) + st
  end

end
end
end
