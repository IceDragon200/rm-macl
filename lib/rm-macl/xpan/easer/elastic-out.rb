#
# rm-macl/lib/rm-macl/xpan/easer/elastic-out.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
  class Easer
    class Elastic::Out < Elastic

      register(:elastic_out)

      def _ease(t, st, ch, d)
        a, p = @a, @p
        s = 0
        if t == 0
          st
        elsif (t /= d.to_f) >= 1
          st + ch
        else
          p = d * 0.3 if p == 0
          if (a == 0) || (a < ch.abs)
            a = ch
            s = p / 4.0
          else
            s = p / (2 * Math::PI) * Math.asin(ch / a.to_f)
          end
          a * (2 ** (-10 * t)) * Math.sin((t * d - s) * (2 * Math::PI) / p.to_f) + ch + st
        end
      end

    end
  end
end
