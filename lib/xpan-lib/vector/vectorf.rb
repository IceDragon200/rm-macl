#
# RGSS3-MACL/lib/xpan-lib/vector/vectorf.rb
#   by IceDragon
#   dc 01/04/2013
#   dm 01/04/2013
# vr 1.5.0
require File.join(File.dirname(__FILE__), 'vector')

module MACL
class Vectorf < Vector

  def self.default_value
    0.0
  end

  def self.convert_param(param)
    param.to_f
  end

end

class Vector2f < Vectorf

  def self.params
    [:x, :y]
  end

  params.each { |s| make_attr(s) }

end

class Vector3f < Vectorf

  def self.params
    [:x, :y, :z]
  end

  params.each { |s| make_attr(s) }

end

class Vector4f < Vectorf

  def self.params
    [:x, :y, :x2, :y2]
  end

  params.each { |s| make_attr(s) }

end
end
