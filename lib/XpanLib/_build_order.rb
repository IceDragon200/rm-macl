# // Xpansion Library
warn 'TableExpansion is already imported' if ($imported||={})['TableExpansion']
($imported||={})['TableExpansion']=0x10000
# ╒╕ ■                                          MACL::Mixin::TableExpansion ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL::Mixin::TableExpansion
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
# ╒╕ ♥                                                                Point ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
warn 'Point is already imported' if ($imported||={})['Point']
($imported||={})['Point']=0x10002
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
    @x,@y = x,y
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
warn 'Cube is already imported' if ($imported||={})['Cube']
($imported||={})['Cube']=0x10002
# ╒╕ ♥                                                                 Cube ╒╕
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
    def set x=0,y=0,z=0,w=0,h=0,l=0
      @x,@y,@z=x,y,z
      @width,@height,@length=w,h,l
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
warn 'Chitat is already imported' if ($imported||={})['Chitat']
($imported||={})['Chitat']=0x10000
# ╒╕ ■                                                               Chitat ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  class Chitat
    class Stack < Array
      attr_reader :match_data
      def initialize match_data,*args,&block
        @match_data = match_data
        super *args,&block
      end
      alias :arra_inspect :inspect
      def inspect
        "<#{self.class.name} %s: %s>" % [@match_data.to_s, arra_inspect]
      end
    end
    class Tag
      attr_reader :sym,:params
      def initialize sym,match_data
        @sym,@params = sym,match_data.to_a
      end
      def param i
        @params[i]
      end
    end
    attr_accessor :open_rgx,:close_rgx
    attr_reader :tags
    def initialize open_tag=nil,close_tag=nil
      @tags = []
      if open_tag.is_a?(String) and close_tag.is_a?(String)
        open_tag = mk_open_rgx open_tag
        close_tag = mk_close_rgx close_tag
      end
      if !close_tag and open_tag
        mk_and_set_rgx open_tag
      else
        @open_rgx,@close_rgx = open_tag,close_tag
      end
      yield self if block_given?
    end
    # //
    def set_tag sym, regexp
      @tags << {sym: sym, regexp: regexp}
    end
    def mk_tag str
      @tags.each do |hsh|
        sym,regexp = hsh.get_values :sym,:regexp
        mtch = str.match regexp
        return Tag.new sym, mtch if mtch
      end
      return nil
    end
    def mk_open_rgx str
      /<#{str}>/i
    end
    def mk_close_rgx str
      /<\/#{str}>/i
    end
    def mk_and_set_rgx str
      @open_rgx,@close_rgx = mk_open_rgx(str),mk_close_rgx(str)
      self
    end
    def parse_str str
      raise "Regexp has not been set!" unless @open_rgx and @close_rgx
      lines  = str.split(/[\r\n]+/i)
      i,line,result,arra = 0, nil,[],[]
      while i < lines.size
        line = lines[i]
        if mtch = line.match(@open_rgx)
          while true
            i += 1
            line = lines[i]
            break if line =~ @close_rgx
            result << line
            raise "End of note reached!" if i > lines.size
          end
          arra.push Stack.new(mtch,result)
          result = []
        end
        i += 1
      end
      arra
    end
    def parse_str4tags str
      arra = parse_str str
      arra.each do |a| a.collect! { |s| mk_tag s }; a.compact! end
      arra.reject! do |a| a and a.empty? end
      arra
    end
  end
end
warn 'Blaz is already imported' if ($imported||={})['Blaz']
($imported||={})['Blaz']=0x10002
# ╒╕ ♥                                                                 Blaz ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  class Blaz
    include Enumerable
    def initialize &block
      @commands = []
      instance_exec &block if block_given?
    end
    def command_syms
      commands.collect &:first
    end
    def each &block
      @commands.each &block
    end
    attr_accessor :commands
    def to_a
      commands.to_a
    end
    def to_hash
      sym,regex,func,params = [nil]*4
      Hash[commands.collect do |(sym,regex,func,params)| [sym,[regex,func,params]] end]
    end
    def add_command sym,regex,params=[],&func
      @commands.push [sym,regex,func,params]
    end
    def shift_command sym,regex,params=[],&func
      @commands.unshift [sym,regex,func,params]
    end
    def enum_commands
      sym,regex,func,params = [nil]*4
      each do |(sym,regex,func,params)|
        yield sym,regex,func,params
      end
    end
    def match_command str
      sym,regex,func,params = [nil]*4
      enum_commands do |sym,regex,func,params|
        regex = regex.call if regex.respond_to? :call
        mtch = str.match regex
        return if yield sym, mtch, func, params if mtch
      end
    end
    def exec_command str
      sym,mtch,func,params = [nil]*4
      match_command str do |sym,mtch,func,params|
        return func.call mtch
      end
    end
  end
end