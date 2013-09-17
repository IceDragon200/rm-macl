#
# rm-macl/lib/rm-macl/xpan/easer/sine-out.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Sine::Out < Sine

  register(:sine_out)

  def _ease(t, st, ch, d)
    st + ch * Math.sin(t / d * (Math::PI / 2))
  end

end
end
end
