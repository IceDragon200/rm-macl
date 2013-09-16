#
# RGSS3-MACL/lib/xpan-lib/easer/quad-inout.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
  class Easer
    class Quad::InOut < Quad

      register(:quad_inout)

      def _ease(t, st, ch, d)
        if (t /= d / 2.0) < 1
          ch / 2.0 * t ** 2 + st
        else
          -ch / 2.0 * ((t -= 1) * (t - 2) - 1) + st
        end
      end

    end
  end
end
