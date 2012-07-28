# // Xpansion Library
# ╒╕ ■                                               MACL::Mixin::Archijust ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  module Mixin
    module Archijust
      def define_as hash
        hash.each_pair do |k,v| define_method k do v end end
      end
      # // Update on change
      def define_uoc *syms
        syms.each do |sym|
          alias_method "set_#{sym}", "#{sym}="
          module_eval %Q(def #{sym}= n; set_#{sym} n if @#{sym} != n end)
        end
      end
      def define_clamp_writer hash
        hash.each_pair do |k,v|
          module_eval %Q(def #{k}= n; @#{k} = n.clamp(#{v[0]},#{v[1]}) end)
        end
      end
      # // stuff! and stuff
      def define_exfunc sym,&func
        str = sym.to_s+'!'
        define_method str,&func
        define_method sym do |*args,&block| dup.__send__(str,*args,&block) end
      end
    end
  end
end
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
          for z in 0...zsize
            for y in 0...ysize
              for x in 0...xsize
                yield self[x,y,z], x, y, z
              end
            end
          end
        elsif ysize > 1
          for y in 0...ysize
            for x in 0...xsize
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
# ╒╕ ♥                                                                Point ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Point
  def self.convert2point array
    Point.new(*array[0..1])
  end
  attr_accessor :x, :y
  class << self
    alias :[] :new
  end
  def initialize x=0,y=0
    @x,@y = x,y
  end
  def set x=0,y=0
    @x,@y = x||@x,y||@y
    self
  end
  alias old_to_s to_s
  def to_s
    return "<#{self.class.name}: %s, %s>" % [self.x,self.y]
  end
  def to_a
    return @x,@y
  end
  def to_hash
    return {x: @x, y: @y}
  end
  def hash
    return [@x,@y].hash
  end
  def unaries
    return [@x <=> 0, @y <=> 0]
  end
end
# ╒╕ ♥                                                           MACL::Cube ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  class Cube
    SYM_ARGS = [:x,:y,:z,:width,:height,:length]
    attr_accessor *SYM_ARGS
    def initialize *args
      set *args
    end
    def hash
      [@x,@y,@z,@width,@height,@length].hash
    end
    def translate x,y,z
      @x, @y, @z = x, y, z
    end
    def set x=0,y=0,z=0,w=0,h=0,l=0
      @x, @y, @z = x, y, z
      @width, @height, @length = w, h, l
    end
    def xset x=nil,y=nil,z=nil,w=nil,h=nil,l=nil
      x,y,z,w,h,l = *x if x.is_a? Array
      x,y,z,w,h,l = x.get_values *SYM_ARGS  if x.is_a? Hash
      set x||@x,y||@y,z||@z,w||@width,h||@height,l||@length
      self
    end
    # // pass symbols and recive values
    def xto_a *args
      return (args&SYM_ARGS).collect{ |sym| self.send sym }
    end
    def to_a
      return @x, @y, @z, @width, @height, @length
    end
    def to_rect
      Rect.new @x, @y, @width, @height
    end
    def to_hash
      return {x: @x,y: @y,z: @z,width: @width,height: @height,length: @length}
    end
    def to_s
      return "<#{self.class.name}: x%s y%s z%s w%s h%s l%s>" % to_a
    end
    def empty
      set
      self
    end
    def area1
      @width*@height
    end
    def area2
      @width*@length
    end
    def area3
      @height*@length
    end
    def volume
      @width*@height*@length
    end
  end
end
Cube = MACL::Cube