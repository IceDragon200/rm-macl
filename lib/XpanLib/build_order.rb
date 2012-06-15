# // Xpansion Library
warn 'TableExpansion is already imported' if ($imported||={})['TableExpansion']
($imported||={})['TableExpansion']=0x10000
# ╒╕ ■                                          MACL::Mixin::TableExpansion ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL::Mixin::TableExpansion
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
end
# ╒╕ ♥                                                                Point ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
warn 'Point is already imported' if ($imported||={})['Point']
($imported||={})['Point']=0x10000
class Point
  attr_accessor :x, :y
  class << self ; alias :[] :new ; end
  def initialize(x=0,y=0)
    @x, @y = x, y
  end
  def set(x=0,y=0)
    @x, @y = x, y
    self
  end
  alias old_to_s to_s
  def to_s
    "<Point: %s, %s>" % [self.x,self.y]
  end
  def to_a
    return @x,@y
  end
  def to_hsh
    return {x: @x, y: @y}
  end
  def hash
    [@x,@y].hash
  end
end
# ╒╕ ■                                                               Chitat ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
warn 'Chitat is already imported' if ($imported||={})['Chitat']
($imported||={})['Chitat']=0x10000
class Chitat
  class Stack < Array
    attr_reader :match_data
    def initialize(match_data,*args,&block)
      @match_data = match_data
      super *args,&block
    end
    alias :arra_inspect :inspect 
    def inspect
      "<Stack %s: %s>" % [@match_data.to_s, arra_inspect]
    end
  end
  class Tag
    attr_reader :sym,:params
    def initialize sym,match_data
      @sym,@params = sym,match_data.to_a
    end
    def param(i)
      @params[i]
    end
  end
  attr_accessor :open_rgx,:close_rgx
  attr_reader :tags
  def initialize open_tag=nil,close_tag=nil
    @tags = []
    if open_tag.is_a?(String) and close_tag.is_a?(String)
      open_tag = mk_open_rgx(open_tag) 
      close_tag = mk_close_rgx(close_tag) 
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
      sym,regexp = hsh.get_values(:sym,:regexp)
      mtch = str.match(regexp)
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
    while(i < lines.size)
      line = lines[i]
      if mtch = line.match(@open_rgx)
        while true 
          i += 1
          line = lines[i]
          break if line =~ @close_rgx
          result << line
          raise "End of note reached!" if(i > lines.size)
        end  
        arra << Stack.new(mtch,result); result = []
      end  
      i += 1
    end
    arra
  end
  def parse_str4tags str
    arra = parse_str str
    arra.each do |a| a.collect!{|s|mk_tag(s)};a.compact! end
    arra.reject! do |a| a and a.empty? end
    arra
  end
end
# ╒╕ ♥                                                                 Blaz ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Blaz
  def initialize &block
    @commands = []
    instance_exec &block if block_given?
  end
  attr_accessor :commands
  def enum_commands
    sym,regex,func = [nil]*3
    @commands.each do |(sym,regex,func)|
      yield sym,regex,func
    end
  end  
  def add_command sym,regex,&func
    @commands << [sym,regex,func]
  end
  def match_command str
    enum_commands do |sym,regex,func|
      regex = regex.call if regex.respond_to? :call
      mtch = str.match(regex)
      return if yield sym, mtch, func if mtch
    end
  end
end