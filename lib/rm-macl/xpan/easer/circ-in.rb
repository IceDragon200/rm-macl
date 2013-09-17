#
# rm-macl/lib/rm-macl/xpan/easer/circ-in.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Circ::In < Circ

  register(:circ_in)

  def _ease(t, st, ch, d)
    -ch * (Math.sqrt(1 - (t/d) * t/d) - 1) + st rescue st
  end

end
end
end
