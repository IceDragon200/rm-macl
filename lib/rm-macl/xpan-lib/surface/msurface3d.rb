#
# RGSS3-MACL/lib/xpan-lib/surface/msurface3d.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 11/05/2013
# vr 1.1.0
require File.join(File.dirname(__FILE__), 'mSurface')

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

    end
  end
end
