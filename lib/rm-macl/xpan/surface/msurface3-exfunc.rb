#
# rm-macl/lib/rm-macl/xpan/surface/msurface3d-exfunc.rb
#
require 'rm-macl/macl-core'
require 'rm-macl/mixin/archijust'
require 'rm-macl/xpan/surface/msurface3'

module MACL
  module Mixin
    module Surface3

      def to_s3a
        return self.x, self.y, self.z, self.x2, self.y2, self.z2
      end

      def to_surface3d
        MACL::Surface3.new(self.x, self.y, self.z, self.x2, self.y2, self.z2)
      end

    end
  end
end
MACL.register('macl/xpan/surface/msurface3-exfunc', '1.1.0')