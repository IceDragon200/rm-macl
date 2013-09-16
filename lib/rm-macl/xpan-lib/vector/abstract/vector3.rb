#
# RGSS3-MACL/lib/xpan-lib/vector/abstract/vector3.rb
#   by IceDragon
#   dc 04/04/2013
#   dm 04/04/2013
# vr 1.5.1
module MACL
  module Abstract
    module Vector3

      def self.included(mod)
        def mod.params
          [:x, :y, :z]
        end
      end

      ##
      # magnitude -> Float
      def magnitude
        Math.sqrt(x * x + y * y + z * z)
      end

      def normalize!
        rad = radian
        # TODO
        self
      end

      def normalize
        return dup.normalize!
      end

    end
  end
end
