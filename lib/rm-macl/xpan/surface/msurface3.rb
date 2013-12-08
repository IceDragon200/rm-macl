#
# rm-macl/lib/rm-macl/xpan/surface/msurface3d.rb
#
require 'rm-macl/macl-core'
require 'rm-macl/mixin/archijust'
require 'rm-macl/xpan/surface/msurface2'

module MACL
  module Mixin
    module Surface3

      extend MACL::Mixin::Archijust
      include MACL::Mixin::Surface2

      def contains?(nx, ny, nz)
        return (x <= nx && nx < x2) && (y <= ny && ny < y2) && (z <= nz && nz < z2)
      end

      def move(x, y, z)
        self.x += x
        self.y += y
        self.z += z
      end

      def moveto(x, y, z)
        self.x, self.y, self.z = x, y, z
      end

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

      def get_by_anchor(anchors)
        super <<
        case anchors[2]
        when 0 then nil
        when 1 then self.z
        when 2 then self.cz
        when 3 then self.z2
        end
      end

      def set_by_anchor(anchors, values)
        super(anchors, values)
        case anchors[2]
        when 0 then
        when 1 then self.z  = values[2]
        when 2 then self.cz = values[2]
        when 3 then self.z2 = values[2]
        end
        self
      end

      def anchor_z(id)
        case id
        when MACL::Surface::Tool::ID_NULL then nil
        when MACL::Surface::Tool::ID_MIN  then self.z
        when MACL::Surface::Tool::ID_MID  then self.cz
        when MACL::Surface::Tool::ID_MAX  then self.z2
        end
      end

      def set_anchor_z(id, n)
        case id
        when MACL::Surface::Tool::ID_NULL then #self.z  = pnt.z
        when MACL::Surface::Tool::ID_MIN  then self.z  = n
        when MACL::Surface::Tool::ID_MID  then self.cz = n
        when MACL::Surface::Tool::ID_MAX  then self.z2 = n
        end
      end

      def points
        [MACL::Vector3I.new(x2, y, z),
         MACL::Vector3I.new(x2, y2, z),
         MACL::Vector3I.new(x2, y2, z2),
         MACL::Vector3I.new(x, y2, z2),
         MACL::Vector3I.new(x, y, z2),
         MACL::Vector3I.new(x, y, z)]
      end

      def to_a
        return x, y, z, width, height, depth
      end

      # as 2D Surface Attribute Array
      def to_s2a
        return x, y, x2, y2
      end

      # as 3D Surface Attribute Array
      def to_s3a
        return x, y, z, x2, y2, z2
      end

      def to_h
        return { x: x, y: y, z: z, width: width, height: height, depth: depth }
      end

      def to_vhash
        return { x: x, y: y, z: z, x2: x2, y2: y2, z2: z2 }
      end

      def to_rect
        Rect.new(x, y, width, height)
      end

      def to_cube
        MACL::Cube.new(x, y, z, width, height, depth)
      end

      def to_surface2
        MACL::Surface::Surface2.new(x, y, x2, y2)
      end

      def to_surface3
        MACL::Surface::Surface3.new(x, y, z, x2, y2, z2)
      end

    end
  end
end
MACL.register('macl/xpan/surface/msurface3', '3.1.0')