#
# rm-macl/lib/rm-macl/xpan/vector/vectori.rb
#
require 'rm-macl/macl-core'
require 'rm-macl/xpan/vector/vector'

module MACL
  module Extension
    module VectorI

      def default_value
        0
      end

      def convert_param(param)
        param.to_i
      end

    end
  end

  class Vector2I < Vector

    include Abstract::Vector2
    extend Extension::VectorI
    make_param_attrs

  end

  class Vector3I < Vector

    include Abstract::Vector3
    extend Extension::VectorI
    make_param_attrs

  end

  class Vector4I < Vector

    include Abstract::Vector4
    extend Extension::VectorI
    make_param_attrs

  end
end
MACL.register('macl/xpan/vector/vectori', '1.6.0')