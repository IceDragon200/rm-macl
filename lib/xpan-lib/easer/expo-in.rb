#
# RGSS3-MACL/lib/xpan-lib/easer/expo-in.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
class Easer
class Expo::In < Expo

  register(:expo_in)

  def _ease(t, st, ch, d)
    t == 0 ? st : ch * (2 ** (10 * (t / d.to_f - 1))) + st
  end

end
end
end
