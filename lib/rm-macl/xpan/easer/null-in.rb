#
# rm-macl/lib/rm-macl/xpan/easer/null-in.rb
#   by IceDragon
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
  class Easer
    class Null::In < Null

      register(:null_in)

      def _ease(t, st, ch, d)
        st
      end

    end
  end
end
