#
# RGSS3-MACL/lib/xpan-lib/surface/msurface.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 11/05/2013
# vr 2.3.0
module MACL
  module Mixin
    module Surface

      extend MACL::Mixin::Archijust

      attr_accessor :freeform

      ##
      # freeform_do
      #   The Surface will enter freeform editing based on the given toggle state
      #   within the block
      #   the original state is restored once the block is completed
      def freeform_do(toggle=true)
        return to_enum(:freeform_do) unless block_given?
        old_freeform = @freeform
        @freeform = toggle
        yield self
        @freeform = old_freeform
      end

      # it is advised that x2, y2 be overwritten for your special class
      ##
      # x2
      def x2
        self.x + self.width
      end

      ##
      # y2
      def y2
        self.y + self.height
      end

      ##
      # x2=(Integer n)
      def x2=(n)
        if @freeform
          self.width = n - self.x
        else
          self.x = n - self.width
        end
      end

      ##
      # y2=(Integer n)
      def y2=(n)
        if @freeform
          self.height = n - self.y
        else
          self.y = n - self.height
        end
      end

      ##
      # cx
      def cx
        x + width / 2
      end

      ##
      # cy
      def cy
        y + height / 2
      end

      ##
      # cx=(Integer x)
      def cx=(x)
        self.x = x - self.width / 2
      end

      ##
      # cy=(Integer y)
      def cy=(y)
        self.y = y - self.height / 2
      end

      ##
      # hset(Hash hash)
      def hset(hash)
        x, y, x2, y2, w, h = hash.get_values(:x, :y, :x2, :y2, :width, :height)

        self.x, self.y          = x || self.x, y || self.y
        self.x2, self.y2        = x2 || self.x2, y2 || self.y2
        self.width, self.height = w || self.width, h || self.height

        return self
      end

      def anchor_x(id)
        case id
        when MACL::Surface::Tool::ID_NULL then nil
        when MACL::Surface::Tool::ID_MIN  then self.x
        when MACL::Surface::Tool::ID_MID  then self.cx
        when MACL::Surface::Tool::ID_MAX  then self.x2
        end
      end

      def anchor_y(id)
        case id
        when MACL::Surface::Tool::ID_NULL then nil
        when MACL::Surface::Tool::ID_MIN  then self.y
        when MACL::Surface::Tool::ID_MID  then self.cy
        when MACL::Surface::Tool::ID_MAX  then self.y2
        end
      end

      def set_anchor_x(id, n)
        case id
        when MACL::Surface::Tool::ID_NULL then #self.x  = pnt.x
        when MACL::Surface::Tool::ID_MIN  then self.x  = n
        when MACL::Surface::Tool::ID_MID  then self.cx = n
        when MACL::Surface::Tool::ID_MAX  then self.x2 = n
        end
      end

      def set_anchor_y(id, n)
        case id
        when MACL::Surface::Tool::ID_NULL then #self.y  = pnt.y
        when MACL::Surface::Tool::ID_MIN  then self.y  = n
        when MACL::Surface::Tool::ID_MID  then self.cy = n
        when MACL::Surface::Tool::ID_MAX  then self.y2 = n
        end
      end

      ##
      # anchor_point(anchor) -> Point
      #   Calculates and returns the "Anchor" Point (x, y[, z]) Surface
      def anchor_point_abs_a(anchor)
        anchor_ids = MACL::Surface::Tool.anchor_to_ids(anchor)
        x = anchor_x(anchor_ids[0])
        y = anchor_y(anchor_ids[1])
        if surface_3d?
          z = anchor_z(anchor_ids[2])
          return [x, y, z]
        else
          return [x, y]
        end
      end

      def anchor_point(anchor)
        x, y, z = anchor_point_abs_a(anchor)
        if surface_3d?
          return MACL::Point3d.new(x, y, z)
        else
          return MACL::Point2d.new(x, y)
        end
      end

      ##
      # points -> | if surface_3d? Array<Point3d>
      # points -> | else           Array<Point2d>
      #   using right hand rule
      def points
        if surface_3d?
          [MACL::Point3d.new(x2, y, z),
           MACL::Point3d.new(x2, y2, z),
           MACL::Point3d.new(x2, y2, z2),
           MACL::Point3d.new(x, y2, z2),
           MACL::Point3d.new(x, y, z2),
           MACL::Point3d.new(x, y, z)]
        else
          [MACL::Point2d.new(x2, y),
           MACL::Point2d.new(x2, y2),
           MACL::Point2d.new(x, y2),
           MACL::Point2d.new(x, y)]
        end
      end

    end
  end
end
