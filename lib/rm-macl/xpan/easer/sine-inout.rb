#
# rm-macl/lib/rm-macl/xpan/easer/sine-inout.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Sine::InOut < Sine

  register(:sine_inout)

  def _ease(t, st, ch, d)
    st + -ch / 2.0 * (Math.cos(Math::PI * t / d) - 1)
  end

end
end
end
