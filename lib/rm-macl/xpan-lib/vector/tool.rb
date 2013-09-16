#
# RGSS3-MACL/lib/xpan-lib/vector/Tool.rb
#   by IceDragon
#   dc 10/04/2013
#   dm 16/04/2013
# vr 0.1.0
module MACL
  class Vector
    module Tool

      ##
      # ::distance2(Vector2 v1, Vector2 v2)
      def self::distance2(vec1, vec2)
        return Math.sqrt((vec1.x - vec2.x) ** 2 + (vec1.y - vec2.y) ** 2)
      end

      ##
      # ::distance3(Vector3 v1, Vector3 v2)
      def self::distance3(vec1, vec2)
        return Math.sqrt((vec1.x - vec2.x) ** 2 +
                         (vec1.y - vec2.y) ** 2 +
                         (vec1.z - vec2.z) ** 2)
      end

    end
  end
end
