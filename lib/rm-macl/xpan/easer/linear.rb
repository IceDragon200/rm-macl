#
# rm-macl/lib/rm-macl/xpan/easer/linear.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
  class Easer
    class Linear < Easer

      register(:linear)

      def _ease(t, st, ch, d)
        ch * t / d + st
      end

    end
  end
end
