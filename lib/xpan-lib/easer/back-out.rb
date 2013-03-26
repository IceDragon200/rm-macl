#
# RGSS3-MACL/lib/xpan-lib/easer/back-out.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Back::Out < Back

  register(:back_out)

  def _ease(t, st, ch, d)
    ch * ((t=t/d-1) * t * ((@s+1) * t + @s) + 1) + st
  end

end
end
end
