#
# RGSS3-MACL/lib/xpan-lib/easer/null-out.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Null::Out < Null

  register(:null_out)

  def _ease(t, st, ch, d)
    st + ch
  end

end
end
end
