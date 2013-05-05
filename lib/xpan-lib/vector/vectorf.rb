#
# RGSS3-MACL/lib/xpan-lib/vector/vectorf.rb
#   by IceDragon
#   dc 01/04/2013
#   dm 01/04/2013
# vr 1.5.0
require File.join(File.dirname(__FILE__), 'vector')

module MACL
module Extender
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
  extend Extender::VectorF
  make_param_attrs

end

class Vector3F < Vector

  include Abstract::Vector3
  extend Extender::VectorF
  make_param_attrs

end

class Vector4F < Vector

  include Abstract::Vector4
  extend Extender::VectorF
  make_param_attrs

end
end
