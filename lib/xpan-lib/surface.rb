#
# RGSS3-MACL/lib/xpan-lib/surface.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 06/05/2013
# vr 1.4.1
module MACL
  class Surface

    VERSION = '1.4.1'.freeze

  end
end

dir = File.dirname(__FILE__)
require File.join(dir, "vector")
%w(Constants mSurface mSurface-exfunc SurfaceError Surface Surface-to_func
   Surface-Tool mSurface3D mSurface3D-exfunc Surface3D).each do |fn|
  require File.join(dir, 'surface', fn)
end
