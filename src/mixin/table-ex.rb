#
# src/xpan-lib/table-ex
#
module MACL
  module Mixin
    module TableExpansion


      def nudge(nx, ny, nz)
        tabclone = self.dup
        xs, ys, zs = tabclone.xsize, tabclone.ysize, tabclone.zsize
        if zs > 1
          for z in 0...zs
          tabclone.iterate do |i,x,y,z| self[(x+nx)%xs,(y+ny)%ys,(z+nz)%zs] = i end
        elsif ys > 0
          tabclone.iterate do |i,x,y| self[(x+nx)%xs,(y+ny)%ys] = i end
        else
          tabclone.iterate do |i,x| self[(x+nx)%xs] = i end
        end
        self
      end

      def oor?(x, y=0, z=0)
        return true if x < 0 || y < 0 || z < 0
        return true if xsize <= x
        return true if ysize <= y if ysize > 0
        return true if zsize <= z if zsize > 0
        return false
      end

    end
  end
end
