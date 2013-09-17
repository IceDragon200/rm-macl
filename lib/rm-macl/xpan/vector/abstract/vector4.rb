#
# rm-macl/lib/rm-macl/xpan/vector/abstract/vector4.rb
#
require 'rm-macl/macl-core'
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
MACL.register('macl/abstract/vector/vector4', '1.6.0')