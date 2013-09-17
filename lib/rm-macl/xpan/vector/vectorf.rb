#
# rm-macl/lib/rm-macl/xpan/vector/vectorf.rb
#
require 'rm-macl/macl-core'
require 'rm-macl/xpan/vector/vector'

module MACL
  module Extension
    module VectorF

      def default_value
        0.0
      end

      def convert_param(param)
        param.to_f
      end

    end
  end

  class Vector2F < Vector

    include Abstract::Vector2
    extend Extension::VectorF
    make_param_attrs

  end

  class Vector3F < Vector

    include Abstract::Vector3
    extend Extension::VectorF
    make_param_attrs

  end

  class Vector4F < Vector

    include Abstract::Vector4
    extend Extension::VectorF
    make_param_attrs

  end
end
MACL.register('macl/xpan/vector/vectorf', '1.6.0')