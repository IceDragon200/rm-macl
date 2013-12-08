#
# rm-macl/lib/rm-macl/xpan/easer/bounce-out.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
  class Easer
    class Bounce::Out < Bounce

      register(:bounce_out)

      def _ease(t, st, ch, d)
        if (t /= d) < (1/2.75)
          ch * (7.5625 * t * t) + st
        elsif t < (2 / 2.75)
          ch * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + st
        elsif t < (2.5 / 2.75)
          ch * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + st
        else
          ch * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + st
        end
      end

    end
  end
end