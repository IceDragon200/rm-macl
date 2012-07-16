# ╒╕ ■                                          MACL::Mixin::TableExpansion ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  module Mixin
    module TableExpansion
      def area
        xsize*ysize
      end
      def volume
        xsize*ysize*zsize
      end
      def iterate
        x,y,z=[0]*3
        if zsize > 1
          for x in 0...xsize
            for y in 0...ysize
              for z in 0...zsize
                yield self[x,y,z], x, y, z
              end
            end
          end
        elsif ysize > 1
          for x in 0...xsize
            for y in 0...ysize
              yield self[x,y], x, y
            end
          end  
        else
          for x in 0...xsize
            yield self[x], x
          end  
        end
        Graphics.frame_reset
        self
      end
      def iterate_map
        i=0;xyz=[0,0,0]
        iterate do |i,*xyz|
          self[*xyz] = yield i, *xyz
        end
        self
      end
      def replace table
        i=0;xyz=[0,0,0]
        resize table.xsize, table.ysize, table.zsize
        iterate do |i,*xyz|
          self[*xyz] = table[*xyz]
        end
        self
      end
      def clear
        resize 1
        self
      end
      def nudge nx,ny,nz 
        tabclone = self.dup
        xs,ys,zs = tabclone.xsize, tabclone.ysize,tabclone.zsize
        i,x,y,z=[0]*4
        if zs > 0
          tabclone.iterate do |i,x,y,z| self[(x+nx)%xs,(y+ny)%ys,(z+nz)%zs] = i end
        elsif ys > 0  
          tabclone.iterate do |i,x,y| self[(x+nx)%xs,(y+ny)%ys] = i end
        else  
          tabclone.iterate do |i,x| self[(x+nx)%xs] = i end
        end  
        self
      end  
      def oor? x,y=0,z=0
        return true if x < 0 || y < 0 || z < 0
        return true if xsize <= x
        return true if ysize <= y if ysize > 0
        return true if zsize <= z if zsize > 0
        return false
      end
      def to_a
        tabe = begin
          if @zsize > 1
            Array.new @xsize do 
              Array.new @ysize do 
                Array.new @zsize, 0 
              end 
            end
          elsif @ysize > 1
            Array.new @xsize do 
              Array.new @ysize, 0
            end
          else
            Array.new @xsize, 0
          end
        end  
        x,y,z,n,xyz = [nil]*5
        iterate do |n,*xyz|
          x,y,z = *xyz
          if xyz.size == 3
            tabe[x][y][z] = n
          elsif xyz.size == 2
            tabe[x][y] = n
          else
            tabe[x] = n  
          end
        end
        tabe
      end
    end
  end
end