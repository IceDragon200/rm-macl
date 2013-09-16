#
# RGSS3-MACL/lib/xpan-lib/easer/back-in.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
  class Easer
    class Back::In < Back

      register(:back_in)

      def _ease(t, st, ch, d)
        ch * (t/=d) * t * ((@s+1) * t - @s) + st
      end

    end
  end
end
