#
# rm-macl/lib/rm-macl/xpan/easer/expo-inout.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
  class Easer
    class Expo::InOut < Expo

      register(:expo_inout)

      def _ease(t, st, ch, d)
        if t == 0
          st
        elsif t == d
          st + ch
        elsif (t /= d / 2.0) < 1
          ch / 2.0 * (2 ** (10 * (t - 1))) + st
        else
          ch / 2.0 * (-(2 ** (-10 * (t -= 1))) + 2) + st
        end
      end

    end
  end
end