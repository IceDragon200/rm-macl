#
# rm-macl/lib/rm-macl/xpan/easer/sine-in.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Sine::In < Sine

  register(:sine_in)

  def _ease(t, st, ch, d)
    st + -ch * Math.cos(t / d * (Math::PI / 2)) + ch
  end

end
end
end
