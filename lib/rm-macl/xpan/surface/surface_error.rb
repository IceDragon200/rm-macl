#
# rm-macl/lib/rm-macl/xpan/surface/surface-error.rb
#   by IceDragon
require 'rm-macl/macl-core'
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
MACL.register('macl/xpan/surface/error', '1.1.0')