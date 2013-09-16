#
# RGSS3-MACL/lib/xpan-lib/vector/abstract/vector4.rb
#   by IceDragon
#   dc 04/04/2013
#   dm 04/04/2013
# vr 1.5.1
module MACL
  module Abstract
    module Vector4

      def self.included(mod)
        def mod.params
          [:x, :y, :x2, :y2]
        end
      end

    end
  end
end
