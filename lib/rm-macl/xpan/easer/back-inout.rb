#
# rm-macl/lib/rm-macl/xpan/easer/back-inout.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.1
module MACL
  class Easer
    class Back::InOut < Back

      register(:back_inout)

      def _ease(t, st, ch, d)
        if (t /= d/2.0) < 1
          ch / 2.0 * (t * t * (((@s *= (1.525)) + 1) * t - @s)) + st
        else
          ch / 2.0 * ((t -= 2) * t * (((@s *= (1.525)) + 1) * t + @s) + 2) + st
        end
      end

    end
  end
end