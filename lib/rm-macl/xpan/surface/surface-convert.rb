#
# rm-macl/lib/rm-macl/xpan/surface/surface_to.rb
#
require 'rm-macl/macl-core'
require 'rm-macl/mixin/archijust'
require 'rm-macl/xpan/surface/surface'
require 'rm-macl/xpan/surface/surface3'

module MACL
  module Mixin
    module Surface

      def to_a
        return self.x, self.y, self.width, self.height
      end

      # as 2D Surface Attribute Array
      def to_sa
        return self.x, self.y, self.x2, self.y2
      end

      # as 3D Surface Attribute Array
      def to_s3a
        return self.x, self.y, 0, self.x2, self.y2, 0
      end

      def to_h
        return { x: self.x, y: self.y, width: self.width, height: self.height}
      end

      def to_vhash
        return { x: self.x, y: self.y, x2: self.x2, y2: self.y2 }
      end

      def to_rect
        Rect.new(self.x, self.y, self.width, self.height)
      end

      def to_surface
        MACL::Surface.new(self.x, self.y, self.x2, self.y2)
      end

      def to_surface3d
        MACL::Surface3.new(self.x, self.y, 0, self.x2, self.y2, 0)
      end

    end
  end
end
MACL.register('macl/xpan/surface/convert', '1.1.0')