#
# RGSS3-MACL/lib/xpan-lib/vector/vectori.rb
#   by IceDragon
#   dc 01/04/2013
#   dm 01/04/2013
# vr 1.5.0
require File.join(File.dirname(__FILE__), 'vector')

module MACL
module Extender
module VectorI

  def self.default_value
    0
  end

  def self.convert_param(param)
    param.to_i
  end

end
end

class Vector2I < Vector

  include Abstract::Vector2
  extend Extender::VectorI
  make_param_attrs

end

class Vector3I < Vector

  include Abstract::Vector3
  extend Extender::VectorI
  make_param_attrs

end

class Vector4I < Vector

  include Abstract::Vector4
  extend Extender::VectorI
  make_param_attrs

end
end
