#
# RGSS3-MACL/lib/xpan-lib/surface/msurface3d-exfunc.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.0.1
require File.join(File.dirname(__FILE__), 'msurface3d')

module MACL
module Mixin
module Surface3D

  def to_s3a
    return self.x, self.y, self.z, self.x2, self.y2, self.z2
  end

  def to_surface3d
    MACL::Surface3D.new(self.x, self.y, self.z, self.x2, self.y2, self.z2)
  end

end
end
end
