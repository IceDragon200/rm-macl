#
# rm-macl/lib/rm-macl/xpan/vector/abstract/vector3.rb
#
require 'rm-macl/macl-core'
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
MACL.register('macl/abstract/vector/vector3', '1.6.0')