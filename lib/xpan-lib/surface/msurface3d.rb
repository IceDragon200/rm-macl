#
# RGSS3-MACL/lib/xpan-lib/surface/msurface3d.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.0.1
require File.join(File.dirname(__FILE__), 'msurface')

module MACL
module Mixin
module Surface3D

  extend MACL::Mixin::Archijust

  include MACL::Mixin::Surface

  def z2
    return self.z + self.depth
  end

  def z2=(n)
    unless @freeform
      self.z = n - self.depth
    else
      self.depth = n - self.z
    end
  end

  def cz
    return self.z + self.depth / 2
  end

  def cz=(x)
    self.z = self.z - self.depth / 2
  end

end
end
end
