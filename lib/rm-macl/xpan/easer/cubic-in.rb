#
# rm-macl/lib/rm-macl/xpan/easer/cubic-in.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
  class Easer
    class Cubic::In < Cubic

      register(:cubic_in)

      def _ease(t, st, ch, d)
        ch * (t /= d) * t * t + st
      end

    end
  end
end