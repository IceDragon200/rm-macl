#
# RGSS3-MACL/lib/xpan-lib/surface/surface-error.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.0.1
module MACL
module Mixin
module Surface

  class SurfaceError < StandardError
  end

  class SurfaceAnchorError < SurfaceError

    def self.mk(anchor)
      new("Invalid Surface Anchor #{anchor}")
    end

  end

end
end
end
