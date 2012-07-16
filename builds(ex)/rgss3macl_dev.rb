=begin
 ──────────────────────────────────────────────────────────────────────────────
 RGSS3-MACL
 Version : 0x1000B
 Last Build: 13/07/2012 (MM/DD/YYYY) (0x1000A)
 Date Built: 13/07/2012 (MM/DD/YYYY) (0x1000B)
 ──────────────────────────────────────────────────────────────────────────────
 ■ Module
 ♥ Class
=end
# // Standard Library
# ╒╕ ♥                                                               Object ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Object
  def deep_clone
    Marshal.load Marshal.dump(self) 
  end
  def if_eql? obj,alt=nil
    return self.eql?(obj) ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_eql? 
  def if_neql? obj,alt=nil
    return (!self.eql?(obj)) ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_neql? 
  def if_nil? alt=nil
    return self.nil? ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_nil?
  def to_bool
    !!self
  end unless method_defined? :to_bool
end
# ╒╕ ♥                                                               Module ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Module
  def memoize *syms
    syms.each do |sym|
      nm = 'pre_memoize_%s' % sym.to_s
      alias_method nm, sym
      module_eval %Q(
        def #{sym}(*args); @#{'memoize_%s' % sym.to_s}||=#{nm}(*args) end
      )
    end
  end unless method_defined? :memoize
  def memoize_as hash
    hash.each_pair do |sym,n|
      module_eval %Q(def #{sym}; @#{sym}||=#{n} end)
    end
  end unless method_defined? :memoize_as
end
# ╒╕ ♥                                                        Error_NoSkinj ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Error_NoSkinj < StandardError
  def message
    'Skinj is not installed!'
  end
end
# ╒╕ ■                                                               Kernel ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module Kernel
  def load_data filename 
    obj = nil
    File.open filename,"rb" do |f| obj = Marshal.load f  end
    obj
  end unless method_defined? :load_data
  def save_data obj,filename 
    File.open filename,"wb" do |f| Marshal.dump obj, f  end
  end unless method_defined? :save_data
  def load_data_cin filename 
    save_data yield,filename  unless FileTest.exist? filename 
    load_data filename 
  end unless method_defined? :load_data_cin
  def Boolean obj 
    !!obj
  end unless method_defined? :Boolean
  def skinj_eval hsh
    raise Error_NoSkinj.new unless ($imported||={})['Skinj']
    eval_string  = hsh[:eval_string]
    binding      = hsh[:binding]
    skinj_params = hsh[:skinj_params]
    result = Skinj.skinj_str str, *skinj_params
    return eval result,binding
  end unless method_defined? :skinj_eval 
end
# ╒╕ ♥                                                              Numeric ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Numeric
  def negative?
    self < 0
  end
  def positive?
    self > 0
  end
  def min n
    n < self ? n : self
  end unless method_defined? :min
  def max n
    n > self ? n : self
  end unless method_defined? :max
  def clamp min,max
    self < min ? min : (self > max ? max : self)
  end unless method_defined? :clamp
  def unary
    self <=> 0
  end unless method_defined? :unary
  def unary_inv
    -pole
  end unless method_defined? :unary_inv
  # // ROMAN and to_roman by Zetu
  ROMAN = {
        1 => "I",    5 => "V",    10 => "X",
       50 => "L",  100 => "C",   500 => "D",
     1000 => "M", 5000 => "" , 10000 => ""
  }
  def to_roman
    value = self
    return '---' if value >= 4000
    base = ""
    for key in ROMAN.keys.sort.reverse
      a = value / key
      case a
      when 0; next
      when 1, 2, 3
        base += ROMAN[key]*a
      when 4
        base += ROMAN[key]
        base += ROMAN[key*5]
      when 5, 6, 7, 8
        base += ROMAN[key*5]
        base += ROMAN[key]*a-5
      when 9
        base += ROMAN[key*10]
        base += ROMAN[key]
      end
      value -= a * key
    end
    return base
  end unless method_defined? :to_roman
end
# ╒╕ ♥                                                               String ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class String
  def indent *args
    dup.indent! *args
  end
  def indent! n=0,s=" "
    self.replace s*n+self
  end
  def word_wrap chars=80
    char_count = 0
    arra = []
    result_str = ''
    self.scan(/(\S+)/i).each do |str|
      if char_count + str.size < str.chars
        char_count += str.size
        arra << str
      else
        result_str += arra.join(' ')+"\n"
        char_count,arra = 0,[]
      end
    end
  end
  def word_wrap! chars=80
    self.replace word_wrap(chars)
  end
  def character_wrap characters=459
    text = self
    return text if characters <= 0
    white_space = " "
    result,r = [],""
    text.split(' ').each do |word|
      (result << r;r = "") if r.size + word.size > characters
      r << word+white_space
    end
    result << r unless r.empty?
    result
  end
  def as_bool
    case self.upcase
      when *MACL::Parser::STRS_TRUE  ; return true
      when *MACL::Parser::STRS_FALSE ; return false
      else                           ; return nil
    end
  end
end
# ╒╕ ■                                                           Enumerable ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module Enumerable
  def pick
    self[rand(self.size)] 
  end unless method_defined? :pick 
  def reverse_index obj=nil
    if block_given? ; size.downto(0) do |i| return i if yield(self[i]) end
    else            ; size.downto(0) do |i| return i if self[i] == obj end
    end
    -1
  end
  def invoke meth_sym,*args,&block 
    each { |o| o.send(meth_sym,*args,&block) };self
  end
  def invoke_collect meth_sym,*args,&block
    collect { |o| o.send(meth_sym,*args,&block) }
  end
end
# ╒╕ ♥                                                                Array ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Array
  def offset obj
    res = self.shift
    self.push obj
    res
  end
  def pick!
    self.delete n=pick;n
  end unless method_defined? :pick! 
  def pad *args,&block
    dup.pad! *args,&block
  end  
  def pad! n,obj=nil
    self.replace(self[0,n]) if self.size > n
    self.push(block_given? ? yield : obj) while self.size < n
    self
  end 
  def uniq_arrays *args,&block
    dup.uniq_arrays *args,&block
  end
  def uniq_arrays! groups 
    all_objs,uniquesets = self, []
    set, lastset, i, group = nil, nil, nil, nil
    while(all_objs.size > 0)
      set = all_objs.clone
      for i in 0...groups.size
        group = groups[i]
        lastset = set
        set = set & group
        set = lastset if(set.empty?())
      end
      uniquesets << set
      all_objs -= set
    end
    self.replace(uniquesets)
    self
  end
  def rotate n=1
    dup.rotate! n 
  end unless method_defined? :rotate
  def rotate! n=1
    return self if empty?
    n %= size
    concat(slice!(0,n))
  end unless method_defined? :rotate!
  def remove_this obj,n=1
    i = 0
    n.times { (i = self.index(obj)) ? self.delete_at(i) : break }; self
  end
end
# ╒╕ ♥                                                                 Hash ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Hash
  def replace_key *args,&block
    dup.replace_key! *args,&block
  end
  def replace_key! hash={}
    k,v = [nil]*2
    if block_given?
      keyz = self.keys
      keyz.each do |k| v = yield k ; self[v] = self.delete k end
    else
      hash.each_pair do |k,v| self[v] = self.delete k end
    end
    self
  end
  def remap &block
    dup.remap! &block
  end
  def remap!
    key,value = [nil]*2
    hsh = self.each_pair.to_a; self.clear
    hsh.each do |(key,value)|
      key,value = yield key,value; self[key] = value
    end
    self
  end
  def get_values *keys
    keys.collect{|a|self[a]}
  end
  def enum2keys
    dup.enum2keys!
  end
  def enum2keys!
    r,key,value = [nil]*3
    replace(inject(Hash.new) do |r,(key,value)|
      case key
      when Enumerable ; key.each { |i| r[i] = value }
      else            ; r[key] = value
      end
      r
    end)
    self
  end
end
# ╒╕ ♥                                                            MatchData ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class MatchData
  def to_hash
    hsh = {}
    return hsh if captures.empty?
    if names.empty? ; (0..10).each do |i| hsh[i] = self[i] end
    else            ; names.each do |s| hsh[s] = self[s] end
    end
    hsh
  end unless method_defined? :to_hash
end
# ╒╕ ■                                                                 MACL ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  @@initialized = []
  @@inits = []
  def self.init
    constants.collect(&method(:const_get)).each(&method(:invoke_init))
    run_init # // Extended scripts
  end
  def self.invoke_init nodule
    nodule.init if nodule.respond_to? :init
  end
  def self.add_init sym,func
    @@inits << [sym,func]
  end
  def self.run_init
    @@inits.each do |(sym,func)|
      p "%s was already initialized" if @@initialized.include? sym
      begin
        func.call 
      rescue Exception => ex
        p 'MACL: %s failed to load:' % sym.to_s
        p ex
        next
      end
      @@initialized << sym
    end
  end
  module Mixin
  end
end
module MACL
  module Constants
    ANCHOR = {
    # // Standard
      null: 0,
      center: 5,
      horizontal: 11, # // Horizontal
      horz: 11,
      horz0: 12, # // Horizontal Top
      horz1: 13, # // Horizontal Mid
      horz2: 14, # // Horizontal Bottom
      # // Vertical
      vertical: 15, # // Vertical
      vert: 15,
      vert0: 16, # // Vertical Top
      vert1: 17, # // Vertical Mid
      vert2: 18, # // Vertical Bottom
      # // Based on NUMPAD
      left: 4,
      right: 6,
      top: 8,
      up: 8,
      bottom: 2,
      down: 2,
      top_left: 7,
      top_right: 9,
      bottom_left: 1,
      bottom_right: 3
    }
  end
end
# ╒╕ ■                                                          MACL::Mixin ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  module Mixin
# ╒╕ ■                                                    BaseItem_NoteScan ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
    module BaseItem_NoteScan
      private
      def pre_note_scan
        @note.each_line { |line| parse_note_line(line, :pre) }
      end
      def note_scan
        @note.each_line { |line| parse_note_line(line, :mid) }
      end
      def post_note_scan
        @note.each_line { |line| parse_note_line(line, :post) }
      end
      def parse_note_line line, section
      end
      public
      def do_note_scan
        pre_note_scan
        note_scan
        post_note_scan
      end
    end
  end
end
# ╒╕ ■                                                           MACL::Dyna ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  module Dyna
    @@w32_funcs = {}
    def self.init
      @@w32_funcs.merge(
        'GPPSA'         => Win32API.new('kernel32', 'GetPrivateProfileStringA', 'pppplp', 'l'),
        'GetClientRect' => Win32API.new('user32', 'GetClientRect', 'lp', 'i'),
        #'GetWindowRect' => Win32API.new('user32', 'GetWindowRect', 'lp', 'i'),
        'FindWindowEx'  => Win32API.new('user32','FindWindowEx','llpp','l')
      )
    end
    def self.mk_null_str(size=256)
      string = "\0" * size
    end
    def self.get_client
      string = mk_null_str(256)
      @w32_funcs['GPPSA'].call('Game','Title','',string,255,".\\Game.ini")
      @w32_funcs['FindWindowEx'].call(0,0,nil,string.delete!("\0"))
    end
    def self.client_rect
      rect = [0, 0, 0, 0].pack('l4')
      @w32_funcs['GetClientRect'].call(client, rect)
      Rect.new(*rect.unpack('l4').map!(&:to_i))
    end
    def self.client
      @client ||= get_client
    end
  end
end
# ╒╕ ■                                                         MACL::Parser ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  module Parser
    @@data_types = {}
    def self.add_data_type *names, &func
      names.each do |n| @@data_types[n] = func end
    end
    def self.data_types
      @@data_types
    end
    add_data_type 'string' , 'str'  do |args|args.map!(&:to_s) end
    add_data_type 'integer', 'int'  do |args|args.map!(&:to_i) end
    add_data_type 'boolean', 'bool' do |args|args.collect!{|s|str2bool(s)} end
    add_data_type 'percent', 'perc' do |args|args.collect!{|s|str2prate(s)} end
    add_data_type 'rate'   , 'rt'   do |args|args|args.collect!{|s|str2rate(s)} end
    add_data_type 'float'  , 'flt'  do |args|args.map!(&:to_f) end
    add_data_type 'hex'             do |args|args.map!(&:hex) end  
    STRS_TRUE  = ["TRUE" ,"YES","ON" ,"T","Y"]
    STRS_FALSE = ["FALSE","NO" ,"OFF","F","N"]
    STRS_BOOL  = STRS_TRUE + STRS_FALSE
    module Regexp
      DTTYPES   = /(a-)?(#{MACL::Parser.data_types.keys.join(?|)}):(.*)/i
      KEYNVALUE = /(.+):\s*(.+)/i
      BOOL      = /(?:#{STRS_BOOL.join(?|)})/i
      INT       = /\d+/
      FLT       = /\d+\.\d+/
      PRATE     = /\d+%/i
    end
    def self.Singulize array
      return array.size == 1 ? array[0] : array
    end
    # // Converters
    def self.obj2str *objs
      Singulize(objs.collect do |obj| String obj end)
    end
    def self.str2bool *strs
      Singulize(strs.collect do |str|
        case str.upcase
          when *STRS_TRUE  ; true
          when *STRS_FALSE ; false
          else             ; nil
        end
      end)
    end
    def self.str2int *strs
      Singulize(strs.collect do |str| Integer str end)
    end
    def self.str2flt *strs
      Singulize(strs.collect do |str| Float str end)
    end
    def self.str2prate *strs
      Singulize(strs.collect do |str| str.to_i/100.0 end)
    end
    def self.str2rate *strs
      Singulize(strs.collect do |str| str.to_i/1.0 end)
    end
    def self.str2int_a str
      str.scan(/\d+/).map! &:to_i
    end
    def self.str2array str,splitter=?,
      str.split splitter
    end
    def self.str2obj str,type=:nil
      case type
      when :int, :integer ; str2int str
      when :flt, :float   ; str2flt str
      when :bool,:boolean ; str2bool str
      when :str, :string  ; str.to_s
      else # // Guess type
        if str =~ Regexp::FLT
          str2flt str
        elsif str =~ Regexp::PRATE  
          str2prate str  
        elsif str =~ Regexp::INT
          str2int str
        elsif str =~ Regexp::BOOL_REGEX
          str2bool str
        else # // String
          str.to_s
        end
      end
    end
    # // Get dtstr
    def self.obj_data_type obj
      case obj
      when Float     ; "flt"
      when Numeric   ; "int" # // Float is also Numeric type
      when String    ; "str"
      when true,false; "bool"
      else           ; nil
      end
    end
    # // 100 => int:100, "stuff"=>str:stuff
    def self.obj2dtstr obj
      if obj.is_a?(Array)
        "%s:%s" % [obj_data_type(obj.first),obj.join(?,)]
      else
        type = obj_data_type(obj)
        type ? "%s:%s" % [type,obj] : nil
      end
    end
    # // key: value
    def self.parse_knv_str tag,types=[:nil],has_array=false
      types = Array(types)
      mtch = tag.match Regexp::KEYNVALUE
      return nil unless mtch
      key,value = mtch[1,2]
      values = has_array ? value.split(?,) : Array(value)
      values = values.each_with_index.to_a
      values.collect!{|(n,index)|value2obj(n,types[index]||:nil)}
      return key, values
    end
    # // Chitat Main
    # // str:Stuff, int:2, flt:0.2, bool:TRUE
    def self.parse_dtstr dtstr,return_type=:value
      mtch = dtstr.match Regexp::DTTYPES
      raise "Malformed Data String %s" % dtstr unless mtch
      is_array, dt_type, value = mtch[1,3]
      return is_array, dt_type if return_type == :data_type
      is_array = !!is_array
      parser = @data_types[dt_type.downcase]
      #puts "is_array?[%s] dt_type[%s] value[%s]" % [is_array, dt_type, value]
      value = parser.call(is_array ? value.split(?,) : Array(value))
      return value if return_type == :value
      return is_array, dt_type, value # // return_type == :all
    end
  end
end
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
# ╒╕ ♥                                                     MACL::ArrayTable ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  class ArrayTable
    include MACL::Mixin::TableExpansion
    attr_reader :xsize
    attr_reader :ysize
    attr_reader :zsize
    CAP = 256 ** 4
    def initialize *args,&block 
      resize *args,&block 
    end
    def resize x,y=1,z=1,&block 
      @xsize, @ysize, @zsize = x.min(CAP), y.clamp(1,CAP), z.clamp(1,CAP)
      @data = Array.new(@xsize*@ysize*@zsize,&block)
    end  
    def [] x,y=0,z=0 
      @data[x.min(@xsize) + y.min(@ysize) * @xsize + z.min(@zsize) * @xsize * @ysize]
    end
    def []= *args
      x = args[0].min @xsize 
      y = (args.size > 2 ? args[1] : 0).min @ysize 
      z = (args.size > 3 ? args[2] : 0).min @zsize 
      v = args.pop#.min(CAP)
      @data[x + y * @xsize + z * @xsize * @ysize] = v
    end
    def reset!
      @data.clear()
      @xsize, @ysize, @zsize = 0, 0, 0
    end  
  end
end
# ╒╕ ■                                                       Mixin::Surface ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL::Mixin::Surface
  SYM_ARGS = [:x,:y,:width,:height]
  class SurfaceError < StandardError
  end
  include MACL::Constants  
  extend MACL::Mixin::Archijust
  def rwidth
    self.width
  end
  def rheight
    self.height
  end  
  def vx 
    self.x
  end  
  def vy 
    self.y
  end  
  def vx= n
    self.x = n
  end
  def vy= n
    self.y = n
  end  
  def vx2 
    self.vx + self.rwidth
  end  
  def vy2 
    self.vy + self.rheight
  end  
  def vx2= n
    self.x = n - self.rwidth
  end  
  def vy2= n
    self.y = n - self.rheight
  end 
  def cx
    x+width/2
  end
  def cy
    y+height/2
  end
  def cx= x
    self.x = x - self.width / 2.0
  end
  def cy= y
    self.y = y - self.height / 2.0
  end
  def vset x=nil,y=nil,x2=nil,y2=nil
    self.vx = x  || self.vx
    self.vy = y  || self.vy
    self.vx2= x2 || self.vx2
    self.vy2= y2 || self.vy2
    self
  end 
  def xset x=nil,y=nil,w=nil,h=nil
    x,y,w,h = x.get_values(:x,:y,:width,:height) if(x.is_a?(Hash))
    self.x,self.y,self.width,self.height = x||self.x,y||self.y,w||self.width,h||self.height
    self
  end   
  def mid_x n=0
    self.x + (self.width-n) / 2
  end
  def mid_y n=0
    self.y + (self.height-n) / 2
  end
  def area
    rwidth * rheight
  end  
  def perimeter
    (rwidth * 2) + (rheight * 2)
  end 
  define_as space_rect: Rect.new(0,0,0,0)
  def clamp_to_space 
    v4 = (viewport || Graphics).rect.to_v4
    r = space_rect
    cx = v4.x + r.x
    cw = v4.vx2 - self.rwidth - r.rwidth
    cy = v4.y + r.y
    ch = v4.vy2 - self.rheight - r.rheight
    self.x, self.y = self.x.clamp(cx,cw), self.y.clamp(cy,ch)
  end 
  # . x . Only works with Padded stuff
  #def _surface_padding 
  #  (respond_to?(:padding) ? padding : 0)
  #end  
  def _surface_padding 
    standard_padding
  end  
  def adjust_rect_to_contents rect,pad=_surface_padding
    return rect.contract(pad)
  end
  def adjust_rect_to_window rect,pad=_surface_padding
    return rect.expand(pad)
  end   
  # O_O
  def calc_pressure n,anchor,invert=false
    if anchor == ANCHOR[:horz]
      return 0 if n < self.x || n > self.vx2
      n = n - self.x
      n2 = (self.vx2 - self.x)
      n = n2 - n if invert
      n = n / n2.to_f
    elsif anchor == ANCHOR[:vert]
      return 0 if n < self.y || n > self.vy2
      n = n - self.y
      n2 = (self.vy2 - self.y)
      n = n2 - n if invert
      n = n / n2.to_f
    end  
    return n
  end
  def center child_rect
    Surface.center self, child_rect
  end
  def to_a
    return self.vx, self.vy, self.rwidth, self.rheight
  end
  def to_v4a 
    return self.vx, self.vy, self.vx2, self.vy2
  end
  def to_v4
    Vector4.new *to_v4a
  end
  def to_rect
    Rect.new *to_a
  end
  def xto_a *args,&block
    (args&SYM_ARGS).collect(&(block_given? ? block : proc{|sym|self.send(sym)}))
  end
  def xto_h *args
    Hash[xto_a(*args){|sym|[sym,self.send(sym)]}]
  end
  def in_area? ax, ay
    return ax.between?(self.vx, self.vx2) && 
      ay.between?(self.vy, self.vy2)
  end 
  def intersect? v4  
    return in_area?(v4.x, v4.y) || in_area?(v4.width,v4.height)
  end  ##
  # // Destructive
  define_exfunc 'contract' do |n=0,anchor=5|
    a = [0,0,0,0]
    a = case anchor
    when -1 # // Do nothing!?
      [0,0,0,0]
    when ANCHOR[:horz0]  
      [0,0,-n,0] 
    when ANCHOR[:horz], ANCHOR[:horz1]
      [n,0,-n*2,0] 
    when ANCHOR[:horz2]    
      [n,0,n,0] 
    when ANCHOR[:vert1]        
      [0,-n,0,0] 
    when ANCHOR[:vert], ANCHOR[:vert1]
      [0,n,0,-n*2] 
    when ANCHOR[:vert2]      
      [0,n,0,n] 
    # // NUMPAD
    when ANCHOR[:center]
      [n,n,-n*2,-n*2] 
    when ANCHOR[:top_left]
      [0,0,-n,-n] 
    when ANCHOR[:top_right]
      [n,0,-n,-n] 
    when ANCHOR[:bottom_left]
      [0,n,-n,-n] 
    when ANCHOR[:bottom_right]  
      [n,n,-n,-n] 
    when ANCHOR[:bottom]        
      [0,n,0,-n] 
    when ANCHOR[:left]
      [0,0,-n*2,0] 
    when ANCHOR[:right]  
      [n,0,-n,0] 
    when ANCHOR[:top]    
      [0,0,0,-n*2] 
    else
      raise(SurfaceError,'Invalid Anchor: %s' % anchor)
    end        
    self.x      += a[0]
    self.y      += a[1]
    self.width  += a[2]
    self.height += a[3]
    self
  end
  define_exfunc 'expand' do |n=0,anchor=5|
    contract! -n,anchor
  end
  define_exfunc 'squeeze' do |n=0,invert=false,orn=0|
    n = n.round 0
    unless invert
      self.x += n if orn==0 || orn==1
      self.y += n if orn==0 || orn==2
    end
    self.width  -= n if orn==0 || orn==1
    self.height -= n if orn==0 || orn==2
    self
  end
  define_exfunc 'release' do |n=1,invert=false,orn=0|
    squeeze! -n,invert,orn
  end
  define_exfunc 'xpush' do |n,anchor=-1|
    case anchor
    when -1 # // Do nothing!?
    when ANCHOR[:horz0]  
      self.x += n
    when ANCHOR[:horz], ANCHOR[:horz1]
      # // 
    when ANCHOR[:horz2]    
      self.x -= n
    when ANCHOR[:vert1]        
      self.y += n
    when ANCHOR[:vert], ANCHOR[:vert1]
      # // 
    when ANCHOR[:vert2]  
      self.y -= n    
    # // NUMPAD
    when ANCHOR[:center]
      # // N/A
    when ANCHOR[:top_left]
      self.x += n
      self.y += n
    when ANCHOR[:top_right]
      self.x -= n
      self.y += n
    when ANCHOR[:bottom_left]
      self.x += n
      self.y -= n
    when ANCHOR[:bottom_right]  
      self.x -= n
      self.y -= n
    when ANCHOR[:bottom]        
      self.y -= n
    when ANCHOR[:left]
      self.x -= n
    when ANCHOR[:right]  
      self.x += n
    when ANCHOR[:top]    
      self.y += n
    else
      raise(SurfaceError,'Invalid Anchor: %s' % anchor)
    end 
    self   
  end
  define_exfunc 'xpull' do |n=0,anchor=-1|
    xpush! -n,anchor
  end  
  define_exfunc 'salign' do |anchor=5,r=Graphics.rect|
    case anchor
    when -1 # // Do nothing!?
    when ANCHOR[:horz0]  
      self.x = r.x
    when ANCHOR[:horz], ANCHOR[:horz1]
      self.x = r.mid_x(self.rwidth)
    when ANCHOR[:horz2]    
      self.vx2 = r.vx2
    when ANCHOR[:vert1]        
      self.y = r.y
    when ANCHOR[:vert], ANCHOR[:vert1]
      self.y = r.mid_y(self.rheight)
    when ANCHOR[:vert2]      
      self.vy2 = r.vy2  
    # // NUMPAD
    when ANCHOR[:center]
      self.x = r.mid_x(self.rwidth)
      self.y = r.mid_y(self.rheight)
    when ANCHOR[:top_left]
      self.x   = r.x
      self.y   = r.y
    when ANCHOR[:top_right]
      self.vx2 = r.vx2
      self.y   = r.y
    when ANCHOR[:bottom_left]
      self.x   = r.x
      self.vy2 = r.vy2
    when ANCHOR[:bottom_right]  
      self.vx2 = r.vx2
      self.vy2 = r.vy2
    when ANCHOR[:bottom]        
      self.x   = r.mid_x(self.rwidth)
      self.vy2 = r.vy2
    when ANCHOR[:left]
      self.x   = r.x
      self.y   = r.mid_y(self.rheight)
    when ANCHOR[:right]  
      self.vx2 = r.vx2
      self.y   = r.mid_y(self.rheight)
    when ANCHOR[:top]    
      self.x   = r.mid_x(self.rwidth)
      self.y   = r.y
    end    
    self
  end  
  define_exfunc 'offset' do |n=1.0,anchor=7|
    case anchor
    when ANCHOR[:center]
      # // No move
    when ANCHOR[:top_left]
      self.vy += (self.rheight * n).to_i
      self.vx += (self.rwidth * n).to_i
    when ANCHOR[:top_right]
      self.vy += (self.rheight * n).to_i
      self.vx -= (self.rwidth * n).to_i
    when ANCHOR[:bottom_left]
      self.vy -= (self.rheight * n).to_i
      self.vx += (self.rwidth * n).to_i
    when ANCHOR[:bottom_right]  
      self.vy -= (self.rheight * n).to_i
      self.vx -= (self.rwidth * n).to_i
    when ANCHOR[:left]
      self.vx += (self.rwidth * n).to_i
    when ANCHOR[:top]  
      self.vy += (self.rheight * n).to_i
    when ANCHOR[:right]  
      self.vx -= (self.rwidth * n).to_i
    when ANCHOR[:bottom]      
      self.vy -= (self.rheight * n).to_i
    end
    self
  end
end 
# ╒╕ ♥                                                              Surface ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Surface
  include MACL::Mixin::Surface
  def self.area_rect *objs
    mx = objs.min_by &:x
    my = objs.min_by &:y
    mw = objs.max_by &:vx2
    mh = objs.max_by &:vy2
    return Vector4.v4a_to_rect( [mx.x, my.y, mw.vx2, mh.vy2] )
  end 
  attr_accessor :x,:y,:width,:height
  def initialize x=0,y=0,width=0,height=0
    self.x,self.y,self.width,self.height = x, y, width, height
  end  
  def set *args
    obj,=args
    a = obj.respond_to?(:to_rect) ? obj.to_rect.to_a : args
    self.x,self.y,self.width,self.height = a
  end  
  def empty
    self.x = self.y = self.width = self.height = 0
  end
  def to_s
    "<#{self.class.name} x: #{x} y: #{y} width: #{width} height: #{height}>"
  end
end
def Surface.center r1,r2
  Rect.new r1.x+(r1.width-r2.width)/2,r1.y+(r1.height-r2.height)/2,r2.width,r2.height
end
# ─┤ ● Rect.fit_in ├──────────────────────────────────────────────────────────
def Surface.fit_in source,target
  w,h = source.width, source.height
  if w > h ; scale = target.width.to_f / w
  else     ; scale = target.height.to_f / h
  end
  r = source.dup;r.width,r.height=(w*scale).to_i,(h*scale).to_i;r
end
# ╒╕ ♥                                                                 Rect ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Rect
  include MACL::Mixin::Surface
end  
# ╒╕ ♥                                                              Vector4 ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Vector4
  include MACL::Mixin::Surface
  attr_accessor :x,:y,:width,:height
  def initialize *args
    _set *args
  end
  def _set x=nil,y=nil,w=nil,h=nil
    return self.x,self.y,self.width,self.height = 0,0,0,0 if [x,y,w,h].all? &:nil?
    return self.x,self.y,self.width,self.height = x.to_v4a if x.kind_of?(MACL::Mixin::Surface)
    self.x,self.y,self.width,self.height = x||@x||0,y||@y||0,w||@width||0,h||@height||0
  end
  private :_set
  def set *args
    _set *args
  end
  def rwidth
    self.width - self.x
  end
  def rheight
    self.height - self.y
  end  
  alias vx2 width
  alias vy2 height  
  def to_rect
    self.class.v4a_to_rect to_a
  end
  alias old_to_s to_s
  def to_s
    "<#{self.class.name} x#{x} y#{y} width#{width} height#{height}>"
  end
  def self.v4a_to_rect v4a
    return Rect.new v4a[0],v4a[1],v4a[2]-v4a[0],v4a[3]-v4a[1] 
  end  
end
# ╒╕ ♥                                                               Window ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Window
  include MACL::Mixin::Surface
end
# ╒╕ ■                                                              Pallete ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module Pallete
  @sym_colors = {}
  @ext_colors = {}
  #--------------------------------------------------------------------------#
  # ● module-method :pallete
  #/------------------------------------------------------------------------\#
  # ● Return
  #     Bitmap
  #\------------------------------------------------------------------------/#
  def self.pallete
    @pallete = Cache.system "Pallete" if @pallete.nil? || @pallete.disposed?
    return @pallete
  end
  #--------------------------------------------------------------------------#
  # ● module-method :get_color
  #/------------------------------------------------------------------------\#
  # ● Parameter
  #     index (Integer)
  # ● Return
  #     Color
  #\------------------------------------------------------------------------/#
  def self.get_color index
    pallete.get_pixel (index % 16) * 8, (index / 16) * 8
  end
  #--------------------------------------------------------------------------#
  # ● module-method :sym_color
  #/------------------------------------------------------------------------\#
  # ● Parameter
  #     symbol (Symbol)
  # ● Return
  #     Color
  #\------------------------------------------------------------------------/#
  def self.sym_color symbol
    @ext_colors[symbol] || get_color(@sym_colors[symbol] || 0)
  end
  #--------------------------------------------------------------------------#
  # ● module-method :[]
  #/------------------------------------------------------------------------\#
  # ● Refer to
  #     get_color
  #\------------------------------------------------------------------------/#
  def self.[] n
    n.is_a?(String) ? sym_color(n) : get_color(n)
  end
end
# ╒╕ ■                                                          MACL::Morph ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL::Morph
# ╒╕ ♥                                                               Growth ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
  class Growth
    attr_reader :nodes
    attr_reader :open_nodes
    NODE_DIRECTIONS = [
      [ 0,  0],
      [ 0,  1], # // Down
      [-1,  0], # // Left
      [ 1,  0], # // Right
      [ 0, -1], # // Up
    ]
    attr_accessor :same_dir_rate
    attr_accessor :node_thinning
    def initialize
      @nodes = []
      @open_nodes = [[0, 0, 0]]
      @same_dir_rate = 35 
      @node_thinning = 2
      #@ntable = Table.new( *table_size )
    end 
    def ntable_at( x, y )
      @ntable[x % @ntable.xsize, y % @ntable.ysize]
    end  
    def ntable_set_at( x, y, value )
      @ntable[x % @ntable.xsize, y % @ntable.ysize] = value
    end 
    def table_size
      return 100*2, 100*2
    end  
    def grow_by( n ) 
      n.times { grow } 
      return self 
    end
    def grow
      new_open_nodes = []
      @nodes |= @open_nodes.collect do |c|
        node_count = (c[2] == 0 ? 4 : (3 - (c[0].abs+c[1].abs) / @node_thinning)).max 0
        node_count.times do
          new_open_nodes << random_node( c[0], c[1], c[2] )  
        end
        c
      end
      @open_nodes = new_open_nodes
      return self
    end  
    def final_nodes
      return (@nodes + @open_nodes).uniq
    end  
    def random_node( x, y, from_direction )
      possible_routes = [1, 2, 3, 4] - [5-from_direction]
      if seed_rand(100) < @same_dir_rate 
        dir = from_direction
      else  
        dir = possible_routes[seed_rand(possible_routes.size)]
      end
      nx, ny = *NODE_DIRECTIONS[dir]
      #rx, ry = nx + x, ny + y      
      #return rx, ry, dir
      return nx + x, ny + y, dir
    end 
    def seed_rand( arg )
      seed_gen.nil? ? rand( arg ) : seed_gen.rand( arg )
    end  
    attr_reader :seed_gen
    def set_seed_gen( seed )
      @seed_gen = Random.new( seed )
      return self
    end  
  end  
# ╒╕ ♥                                                               Devour ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
  class Devour
    def initialize( nodes )
      @growth = Growth.new
      @devoured = []
      @nodes = nodes
      @x, @y = 0, 0
    end  
    def set_pos( x, y ) 
      @x, @y = x, y
      self
    end  
    def devour_by( n )
      n.times { devour }
      self
    end  
    def devour
      new_nodes = @growth.grow.open_nodes.collect { |nd| [nd[0]+@x, nd[1]+@y] }
      @devoured |= new_nodes & @nodes
      self
    end  
    def final_nodes
      return @nodes - @devoured
    end 
    def seed_gen
      return @growth.seed_gen
    end  
    def set_seed_gen( seed )
      @growth.set_seed_gen( seed )
      return self
    end
  end  
# ╒╕ ♥                                                             Decimate ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
  class Decimate
    def initialize( nodes )
      @decimated = []
      @nodes = nodes
    end 
    def decimate_by( n )
      n.times { decimate }
      self
    end  
    def decimate
      nds = final_nodes
      @decimated << nds[seed_rand(nds.size)] unless nds.empty?
      self
    end  
    def final_nodes
      return @nodes - @decimated
    end 
    def seed_rand( arg )
      seed_gen.nil? ? rand( arg ) : seed_gen.rand( arg )
    end  
    attr_reader :seed_gen
    def set_seed_gen( seed )
      @seed_gen = Random.new( seed )
      return self
    end 
  end 
end
# DeCasteljau Algorithm 
# Hamburg (Germany), the 19th September 1999. Written by Nils Pipenbrinck aka Submissive/Cubic & $eeN 
# Bezier Curve
# Ported to Ruby by IceDragon
# ╒╕ ♥                                                    MACL::Interpolate ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  module Interpolate
    # // Point dest, a, b; float t
    def self.lerp dest,a,b,t 
      dest.x = a.x + (b.x-a.x)*t
      dest.y = a.y + (b.y-a.y)*t
    end
    # // Point dest, *points; float t 
    def self.bezier dest,t,*points 
      result_points = []; pnt = nil
      wpoints = points
      begin 
        for i in 0...(wpoints.size-1)
          pnt = Point[0,0] 
          lerp pnt,wpoints[i],wpoints[i+1],t 
          result_points << pnt
        end
        wpoints = result_points
        result_points = []
      end until wpoints.size <= 2 
      raise "Not enought points" if wpoints.size != 2
      lerp dest,wpoints[0],wpoints[1],t
      #ab,bc,cd,abbc,bccd = Array.new(5) { Point[0,0] }
      #lerp(ab, a,b,t)           # // point between a and b (green)
      #lerp(bc, b,c,t)           # // point between b and c (green)
      #lerp(cd, c,d,t)           # // point between c and d (green)
      #lerp(abbc, ab,bc,t)       # // point between ab and bc (blue)
      #lerp(bccd, bc,cd,t)       # // point between bc and cd (blue)
      #lerp(dest, abbc,bccd,t)   # // point on the bezier-curve (black)
    end
  end
end
# ╒╕ ♥                                                           MACL::Grid ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  class Grid
    def self.qcell_r columns,rows,cell_width,cell_height,index=0
      new(columns,rows,cell_width,cell_height).cell_r index
    end
    def initialize columns,rows,cell_width,cell_height
      @columns,@rows,@cell_width,@cell_height=columns,rows,cell_width,cell_height
    end
    attr_accessor :columns, :rows
    attr_accessor :cell_width, :cell_height
    def width
      columns * cell_width
    end
    def height
      rows * cell_height
    end
    def area1
      rows*columns
    end
    def area2
      width*height
    end
    def cell_a index=0,y=nil
      return [0,0,0,0] if columns == 0
      index = xy2index index,y if y
      [cell_width*(index%columns),
       cell_height*(index/columns),
       cell_width,cell_height]
    end
    def cell_r index=0,y=nil
      Rect.new 0,0,0,0 if columns == 0
      index = xy2index index,y if y
      Rect.new(
        cell_width*(index%columns),
        cell_height*(index/columns),
        cell_width,cell_height
      )
    end
    def xy2index x,y
       x % columns  +  y * columns
    end
    def column_r x
      Rect.new cell_width * x,0,cell_width,cell_height * rows
    end
    def row_r y
      Rect.new 0,cell_height*y,cell_width*columns,cell_height
    end
    # // Column, index array
    def column_ia x
      (0...rows).collect { |y| xy2index x,y }
    end
    # // Row, index array
    def row_ia y
      (0...columns).collect { |x| xy2index x,y }
    end
  end
  class Grid_Matrix < Grid
    
  end
end
# // 04/19/2012
# // 04/19/2012
# ╒╕ ♥                                                      MACL::Sequencer ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  class Sequencer
    attr_accessor :maxcount
    attr_accessor :index
    attr_accessor :count
    def initialize s, n=10
      self.sequence = s
      @index = 0
      @maxcount = n
      reset_count
    end
    attr_reader :sequence
    def sequence= n
      n = n.to_a if n.is_a? Range
      @sequence = n
    end
    def reset_count
      @count = @maxcount
    end
    def value
      @sequence[@index]
    end
    def update
      @count = @count.pred.max 0
      if @count == 0
        @index = @index.succ.modulo @sequence.size
        @count = @maxcount
      end
    end
  end
# ╒╕ ♥                                                       MACL::Sequenex ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
  class Sequenex
    attr_accessor :list, :index, :reversed, :cycles, :cycle_index
    def initialize
      clear!
    end
    def add obj
      a = [obj.respond_to?(:done?),obj.respond_to?(:reset!),obj.respond_to?(:update)]
      unless a.all?
        err,name = NoMethodError, obj.class.name
        raise(err,'%s requires a "done?" method'  % name) unless a[0]
        raise(err,'%s requires a "reset!" method' % name) unless a[1]
        raise(err,'%s requires a "update" method' % name) unless a[2]
      end
      @list.push(obj)
    end
    def clear!
      @list     = []
      @index    = 0
      @reversed = false
      @cycles   = -1
      @cycle_index = 0
    end
    def reset!
      @index = 0
      @list.each &:reset!
    end
    def done?
      @list.all? &:done?
    end
    def reverse!
      @reversed = !@reversed
    end
    def current
      @list[@index]
    end
    def recycle!
      @cycle_index += 1 
      return unless (@cycles == -1 or @cycle_index < @cycles) 
      on_cycle
      reset!
    end
    def on_cycle
    end
    def update
      return if @index >= @list.size
      n = current
      n.update
      if n.done?
        @index = (@reversed ? @index.pred : @index.succ)
        recycle! if @index >= @list.size
        @index = @index.modulo(@list.size)
        n = current
        n.reset! if n
      end  
    end
  end
end
# ╒╕ ♥                                                                Tween ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween
  class TStruct
    attr_accessor :easer,:time
    def initalize easer,time
      @easer,@time = easer,time
    end
    def to_tween start_values,end_values
      Tween.new start_values,end_values,@easer,@time
    end
  end
  class TweenError < StandardError
  end
  attr_reader :values, :start_values, :end_values
  attr_reader :time, :maxtime
  class << self
    def init
      @@_add_time = 1.0 / Graphics.frame_rate
    end
    def _add_time
      @@_add_time
    end    
    def frm2sec frames
      frames * @@_add_time
    end
    def sec2frm sec
      Integer(sec) * Graphics.frame_rate
    end
  end
  def initialize *args,&block
    set_and_reset *args,&block
  end
  def change_time val=nil,max=nil
    @time    = val if val
    @maxtime = max if max
  end
  def value index=0
    return @values[index]
  end
  # // Cross support
  def set *args
    if (hash, = args).is_a?(Hash)
      start_values = hash[:start_values]
      end_values   = hash[:end_values] 
      easer        = hash[:easer]
      maxtime      = hash[:maxtime]
      extra_params = hash[:extra_params]
    else
      start_values, end_values, easer, maxtime, extra_params = *args
    end
    start_values ||= [0]
    end_values ||= [0]
    easer ||= :linear
    maxtime ||= 1.0
    extra_params ||= []
    raise(TweenError,'Invalid easer type: %s' % easer.to_s) unless Tween::EASER_BY_SYMBOL.has_key? easer
    start_values = Array(start_values)
    end_values   = Array(end_values)
    @start_values, @end_values = start_values, end_values
    @easer, @maxtime = easer, maxtime
    @extra_params = extra_params
    scale_values
    @values = []
    update_value @time
  end
  def set_and_reset *args
    reset_time
    set *args
  end
  def scale_values n=1.0
    @start_values = @start_values.collect { |v| v * n }
    @end_values   = @end_values.collect { |v| v * n }
  end
  def change_easer new_easer
    @easer = new_easer
  end
  def reset_time
    @time = 0.0
  end
  def reset!
    reset_time
    update_value_now
  end
  def easer
    return Tween::EASER_BY_SYMBOL[@easer]
  end # // YAY now u can dump it >_>
  def done?
    @time == @maxtime
  end # // Time gets capped anyway
  def pred_time
    @time = (@time-@@_add_time).max 0
  end
  def succ_time
    @time = (@time+@@_add_time).min @maxtime
  end
  def time_rate
    time_to_rate @time
  end
  def time_to_rate t=@time
    t / @maxtime
  end
  def value_at_time time, sv=@start_values[0], ev=@end_values[0], mt=@maxtime, exp=@extra_params
    easer.ease time, sv, ev, mt, *exp
  end
  def invert
    @start_values,@end_values = @end_values,@start_values
    self
  end
  def update_until_done
    yield self while update && !done?
    self
  end
  def update
    succ_time unless done? # // Save a little cpu..
    update_value_now
  end
  def update_value_now
    update_value @time
  end
  def update_value time
    for i in 0...@start_values.size
      @values[i] = value_at_time time, @start_values[i], @end_values[i]
    end
  end
end
# ╒╕ ♥                                                         Tween::Multi ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween::Multi
  attr_reader :tweeners
  def initialize *tweensets
    set *tweensets
  end
  def set *tweensets
    clear
    tweensets.each do |tset|
      add_tween *tset
    end
  end
  def done?
    return @tweeners.all? { |t| t.done? }
  end
  def clear
    @tweeners = []
  end
  def tweener index
    @tweeners[index]
  end
  def tweener_value index, vindex
    @tweeners[index].value vindex
  end
  def tweener_values index
    @tweeners[index].values
  end
  def add_tween *args
    @tweeners << Tween.new(*args)
  end
  def reset
    @tweeners.each do |t| t.reset_time ; end
  end
  def value index
    @tweeners[index].value
  end
  def values
    @tweeners.collect do |t| t.value ; end
  end
  def all_values
    @tweeners.collect { |t| t.values ; }.flatten
  end
  def update
    @tweeners.each do |t| t.update ; end
  end
end
# ╒╕ ♥                                                     Tween::Sequencer ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween::Sequencer < MACL::Sequenex
  def add_tween *args,&block
    add(Tween.new(*args,&block))
  end
  def total_time
    @list.inject(0) { |r, t| r + t.maxtime }
  end
  def values
    current.values
  end
  def value n=0
    current.value n
  end
end
# ╒╕ ♥                                                           Tween::Osc ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween::Osc < Tween::Sequencer
  def initialize *args,&block
    super()
    set *args,&block
    @cycles = -1
    reset!
  end
  def on_cycle
    super
    reverse!
  end
  def set svs, evs, easers=[:linear, :linear], maxtimes=[1.0,1.0]
    for i in 0...easers.size
      args = (i % 2 == 0 ? [svs, evs] : [evs, svs]) + [easers[i], maxtimes[i%maxtimes.size]]
      @list[i] = Tween.new *args
    end
    self
  end
end
# ─┤ ● MACL.add_init ├────────────────────────────────────────────────────────
MACL.add_init :tween, Tween.method(:init)
# ╒╕ ♥                                                         Tween::Easer ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween
  class Easer
    attr_accessor :name,:symbol
    def initialize name=nil,&function
      @name = name || ".Easer"
      @symbol = :__easer
      @function = function
    end
    def _ease *args,&block
      @function.call *args,&block
    end
    def ease et, sv, ev, t, *args
      _ease et, sv, ev-sv, t, *args
    end
  end
  EASERS = []
  EASER_BY_SYMBOL = {}
  def self.add_easer str,&func
    mod,name = str.split("::")
    (name = mod; mod = nil) unless name
    modu = self
    if mod
      module_eval %Q(module #{mod} ; end) # // Initialize module
      modu = const_get(mod) 
    end
    easer = modu.__send__(:const_set,name,Easer.new(str,&func))
    sym   = easer.name.gsub('::',?_).downcase.to_sym
    EASER_BY_SYMBOL[sym] = easer
    EASER_BY_SYMBOL[sym].symbol = sym
    EASERS.push(easer)
  end
  add_easer 'Null::In' do |t, st, ch, d| 
    st
  end
  add_easer 'Null::Out' do |t, st, ch, d|
    ch + st
  end
  add_easer "Linear"  do |t, st, ch, d| 
    ch * t / d + st 
  end
  add_easer "Sine::In"  do |t, st, ch, d|
    -ch * Math.cos(t / d * (Math::PI / 2)) + ch + st
  end
  add_easer "Sine::Out"  do |t, st, ch, d|
    ch * Math.sin(t / d * (Math::PI / 2)) + st
  end
  add_easer "Sine::InOut" do |t, st, ch, d|
    -ch / 2 * (Math.cos(Math::PI * t / d) - 1) + st
  end
  add_easer "Circ::In" do |t, st, ch, d|
    -ch * (Math.sqrt(1 - (t/d) * t/d) - 1) + st rescue st
  end
  add_easer "Circ::Out" do |t, st, ch, d|
    t = t/d - 1 ; ch * Math.sqrt(1 - t * t) + st rescue st
  end
  add_easer "Circ::InOut" do |t, st, ch, d|
    (t /= d/2.0) < 1 ?
     -ch / 2 * (Math.sqrt(1 - t*t) - 1) + st :
      ch / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + st rescue st
  end
  add_easer "Bounce::Out" do |t, st, ch, d|
    if (t /= d) < (1/2.75)
      ch * (7.5625 * t * t) + st
    elsif t < (2 / 2.75)
      ch * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + st
    elsif t < (2.5 / 2.75)
      ch * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + st
    else
      ch * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + st
    end
  end
  add_easer "Bounce::In" do |t, st, ch, d|
    ch - Bounce::Out.ease(d-t, 0, ch, d) + st
  end
  add_easer "Bounce::InOut"  do |t, st, ch, d|
    t < d/2.0 ?
      Bounce::In.ease(t*2.0, 0, ch, d) * 0.5 + st :
      Bounce::Out.ease(t*2.0 - d, 0, ch, d) * 0.5 + ch * 0.5 + st
  end
  add_easer "Back::In" do |t, st, ch, d, s=1.70158|
    ch * (t/=d) * t * ((s+1) * t - s) + st
  end
  add_easer "Back::Out" do |t, st, ch, d, s=1.70158|
    ch * ((t=t/d-1) * t * ((s+1) * t + s) + 1) + st
  end
  add_easer "Back::InOut" do |t, st, ch, d, s=1.70158|
    (t /= d/2.0) < 1 ?
      ch / 2.0 * (t * t * (((s *= (1.525)) + 1) * t - s)) + st :
      ch / 2.0 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + st
  end
  add_easer "Cubic::In" do |t, st, ch, d| 
    ch * (t /= d) * t * t + st 
  end
  add_easer "Cubic::Out" do |t, st, ch, d|
    ch * ((t = t / d.to_f - 1) * t * t + 1) + st
  end
  add_easer "Cubic::InOut" do |t, st, ch, d|
    (t /= d / 2.0) < 1 ?
      ch / 2.0 * t * t * t + st :
      ch / 2.0 * ((t -= 2) * t * t + 2) + st
  end
  add_easer "Expo::In" do |t, st, ch, d|
    t == 0 ? st : ch * (2 ** (10 * (t / d.to_f - 1))) + st
  end
  add_easer "Expo::Out" do |t, st, ch, d|
    t == d ? st + ch : ch * (-(2 ** (-10 * t / d.to_f)) + 1) + st
  end
  add_easer "Expo::InOut" do |t, st, ch, d|
    if t == 0                ; st
    elsif t == d             ; st + ch
    elsif (t /= d / 2.0) < 1 ; ch / 2.0 * (2 ** (10 * (t - 1))) + st
    else                     ; ch / 2.0 * (-(2 ** (-10 * (t -= 1))) + 2) + st
    end
  end
  add_easer "Quad::In" do |t, st, ch, d|
    ch * (t /= d.to_f) * t + st
  end
  add_easer "Quad::Out" do |t, st, ch, d|
    -ch * (t /= d.to_f) * (t - 2) + st
  end
  add_easer "Quad::InOut" do |t, st, ch, d|
    (t /= d / 2.0) < 1 ?
      ch / 2.0 * t ** 2 + st :
      -ch / 2.0 * ((t -= 1) * (t - 2) - 1) + st
  end
  add_easer "Quart::In" do |t, st, ch, d|
    ch * (t /= d.to_f) * t ** 3 + st
  end
  add_easer "Quart::Out" do |t, st, ch, d|
    -ch * ((t = t / d.to_f - 1) * t ** 3 - 1) + st
  end
  add_easer "Quart::InOut" do |t, st, ch, d|
    (t /= d / 2.0) < 1 ?
      ch / 2.0 * t ** 4 + st :
      -ch / 2.0 * ((t -= 2) * t ** 3 - 2) + st
  end
  add_easer "Quint::In" do |t, st, ch, d|
    ch * (t /= d.to_f) * t ** 4 + st
  end
  add_easer "Quint::Out" do |t, st, ch, d|
    ch * ((t = t / d.to_f - 1) * t ** 4 + 1) + st
  end
  add_easer "Quint::InOut" do |t, st, ch, d|
    (t /= d / 2.0) < 1 ?
      ch / 2.0 * t ** 5 + st :
      ch / 2.0 * ((t -= 2) * t ** 4 + 2) + st
  end
  add_easer "Elastic::In" do |t, st, ch, d, a = 5, p = 0|
    s = 0
    if t == 0
      st
    elsif (t /= d.to_f) >= 1
      st + ch
    else
      p = d * 0.3 if p == 0
      if (a == 0) || (a < ch.abs)
        a = ch
        s = p / 4.0
      else
        s = p / (2 * Math::PI) * Math.asin(ch / a.to_f)
      end
      -(a * (2 ** (10 * (t -= 1))) * Math.sin( (t * d - s) * (2 * Math::PI) / p)) + st
    end
  end
  add_easer "Elastic::Out" do |t, st, ch, d, a = 5, p = 0|
    s = 0
    if t == 0
      st
    elsif (t /= d.to_f) >= 1
      st + ch
    else
      p = d * 0.3 if p == 0
      if (a == 0) || (a < ch.abs)
        a = ch
        s = p / 4.0
      else
        s = p / (2 * Math::PI) * Math.asin(ch / a.to_f)
      end
      a * (2 ** (-10 * t)) * Math.sin((t * d - s) * (2 * Math::PI) / p.to_f) + ch + st
    end
  end
end
class Task
  FUNC_TASK_SELECT = proc do |t| t.update;!t.done? end 
  @@single = []
  @@loop = []
  class << self
    alias :nnew :new
    def new *args,&block
      obj = nnew *args,&block
      obj.remote = true
      obj
    end
    def add_task time,&func
      @@single << nnew(time,&func)
    end
    def add_task_loop time,&func
      @@loop << Looped.nnew(time,&func)
    end
    def clear
      (@@single+@@loop).each do |t| t.terminate end
      @@single.clear;@@loop.clear
    end
    def update
      return if @paused
      update_tasks
    end
    def update_tasks
      @@single.select! &FUNC_TASK_SELECT
      @@loop.select! &FUNC_TASK_SELECT
    end
    def pause
      @paused = true
    end
    def unpause
      @paused = false
    end
    alias resume unpause
  end
  class Looped < self
    def update
      return unless super
      reset! if @called
    end
  end
  attr_accessor :time, :function, :called  
  def initialize time, &function
    @time_cap = @time = time
    @function = function
    @terminated, @called = [false]*2
    @remote = false
  end
  def terminate
    @terminated = true
  end
  def update
    return false if @terminated
    @time = @time.pred.max 0 if @time > 0
    (@function.call; @called = true) if @time == 0 unless @called
    true
  end
  def reset!
    @time = @time_cap
    @called = false
  end
  attr_accessor :remote
  def remote?
    @remote
  end
  def done?
    @time == 0 and @called
  end
end
# ╒╕ ♥                                                           MACL::Fifo ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  class Fifo
    include Enumerable
    def initialize size=1,defz=nil,&block
      @data = Array.new
      @default = defz
      resize! size, &block
    end
    def _clamp_range rng
      rng.first.max(0)..rng.last.min(@size)
    end
    def at *args
      raise(ArgumentError,'No Parameters given') if args.size == 0
      if args.size == 1
        n, = args
        if n.is_a? Numeric  ; return @data[n.to_i % @size]
        elsif n.is_a? Range ; return @data[_clamp_range(n)]
        end 
      else
        raise(ArgumentError,'All Parameters must be Numeric') unless args.all? {|i|i.is_a?(Numeric)}
        return args.collect{|i|@data[i.to_i % @size]}
      end
      @default  
    end
    alias :[] :at
    def sample
      @data.sample
    end
    def push_these *objs
      for obj in objs do @data.offset obj end 
      self
    end
    def pull_these replacement=@default,*objs
      unless block_given?
        @data.each_with_index do |n,i|
          @data[i] = replacement if objs.include? n 
        end
      else
        @data.each_with_index do |n,i|
          @data[i] = yield i if objs.include? n 
        end
      end      
      self
    end
    #private :push_these, :pull_these
    def replica
      result = Fifo.new 
      result.replace @data.clone
      result.default = @default
      result
    end
    alias clone replica
    alias dup replica
    def each &block
      @data.each &block
    end
    attr_accessor :default
    def + obj
      replica.push_these *obj.to_a
    end
    def - obj
      replica.pull_these @default,*obj.to_a
    end
    def * obj
      @data * obj
    end
    def push obj
      push_these *obj
    end
    alias :concat :+
    alias :<< :push
    def reject! &block
      self.patch(reject &block)
    end
    def select! &block
      self.patch(select &block)
    end
    def collect! &block
      self.patch(collect &block)
    end
    def size
      @size
    end
    def resize! new_size,elem=@default,&block
      @size = new_size.max(1)
      refresh elem,&block
    end
    def refresh elem=@default,&block
      if @data.size < @size
        count = 0
        if block_given? 
          until @data.size == @size
            @data.push(yield count) 
            count += 1
          end  
        else
          @data.push elem until @data.size == @size
        end 
      elsif @data.size > @size
        @data.shift until @data.size == @size
      end
      self
    end
    private :refresh
    def resize *args,&block
      dup.resize! *args,&block
    end
    def to_a
      @data.dup
    end
    def to_hash
      Hash[to_a.each_with_index.to_a]
    end
    alias org_to_s to_s
    def to_s
      "<#{self.class.name}:%s>" % @data.inspect
    end
    def replace obj
      @data.replace obj.to_a
      self
    end
    def patch obj
      @data.replace obj.to_a
      refresh
    end
    alias org_hash hash
    def hash
      @data.hash
    end
  end
end
# ╒╕ ■                                                         MACL::Chitat ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  class Chitat
    class Stack < Array
      attr_reader :match_data
      def initialize match_data,*args,&block
        @match_data = match_data
        super *args,&block
      end
      alias arra_inspect inspect
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
($imported||={})['MACL::Blaz']=0x10002
# ╒╕ ♥                                                           MACL::Blaz ╒╕
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
#// RGGSEx
# ╒╕ ■                                                          RPG::Metric ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module RPG
  module Metric
    COLOR_CAP    = 255
    COLOR_BASE   = 0
    TONE_CAP     = 255
    TONE_BASE    = 0
    OPACITY_CAP  = 255
    OPACITY_BASE = 0
  end  
end
# ╒╕ ■                                                             Graphics ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class << Graphics
  def rect
    Rect.new(0,0,width,height)
  end unless method_defined? :rect 
  def frames_to_sec frames 
    frames / frame_rate.to_f
  end    
  alias frm2sec frames_to_sec
  def sec_to_frames sec
    sec * frame_rate
  end
  alias sec2frm sec_to_frames
end
# ╒╕ ■                                                                Audio ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module Audio
  @@vol_rate = {
    default: 1.0,
    bgm: 1.0,
    bgs: 1.0,
    me: 1.0,
    se: 1.0
  }
  def self.vol_rate sym
    @@vol_rate[sym]
  end
  def self.vol_rate_set sym,value
    @@vol_rate[sym] = value
  end
end
# ╒╕ ■                                             MACL::Mixin::AudioVolume ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  module Mixin
    module AudioVolume
      def audio_sym
        :default
      end
      def audio_path
        'Audio/%s'
      end
      def vol_rate
        Audio.vol_rate audio_sym
      end
      def volume_abs
        @volume
      end
      def volume
        volume_abs * vol_rate
      end
    end
  end
end
# ╒╕ ♥                                                             RPG::BGM ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class RPG::BGM
  include MACL::Mixin::AudioVolume
  def audio_sym
    :bgm
  end
  def audio_path
    'Audio/BGM/%s'
  end
  def play pos=0
    if @name.empty?
      Audio.bgm_stop
      @@last = RPG::BGM.new
    else
      Audio.bgm_play(audio_path % @name, self.volume, @pitch, pos) rescue nil
      @@last = self.clone
    end
  end
end
# ╒╕ ♥                                                             RPG::BGS ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class RPG::BGS
  include MACL::Mixin::AudioVolume
  def audio_sym
    :bgs
  end
  def audio_path
    'Audio/BGS/%s'
  end
  def play pos=0
    if @name.empty?
      Audio.bgs_stop
      @@last = RPG::BGM.new
    else
      Audio.bgs_play(audio_path % @name, self.volume, @pitch, pos) rescue nil
      @@last = self.clone
    end
  end
end
# ╒╕ ♥                                                              RPG::ME ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class RPG::ME
  include MACL::Mixin::AudioVolume
  def audio_sym
    :me
  end
  def audio_path
    'Audio/ME/%s'
  end
  def play
    if @name.empty?
      Audio.me_stop
      @@last = RPG::BGM.new
    else
      Audio.me_play(audio_path % @name, self.volume, @pitch) rescue nil
      @@last = self.clone
    end
  end
end
# ╒╕ ♥                                                              RPG::SE ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class RPG::SE
  include MACL::Mixin::AudioVolume
  def audio_sym
    :se
  end
  def audio_path
    'Audio/SE/%s'
  end
  def play
    if @name.empty?
      Audio.se_stop
      @@last = RPG::BGM.new
    else
      Audio.se_play(audio_path % @name, self.volume, @pitch) rescue nil
      @@last = self.clone
    end
  end
end
# ╒╕ ♥                                                                Color ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Color
  def hash
    [self.red,self.green,self.blue,self.alpha].hash
  end
  def rgb_sym
    return :red, :green, :blue
  end
  def to_a
    return self.red, self.green, self.blue, self.alpha
  end
  def to_a_na
    return self.red, self.green, self.blue
  end
  alias to_a_ng to_a_na
  def to_hex
    to_a_na.collect{|i|"%02x"%i}.join ''
  end
  def to_flash
    to_hex.hex
  end
  def to_color
    Color.new *to_a
  end
  def to_tone
    Tone.new *to_a
  end
  def to_hash
    {red: red, green: green, blue: blue, alpha: alpha}
  end
end
# ╒╕ ♥                                                                 Tone ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tone
  def rgb_sym
    return :red, :green, :blue
  end
  def to_a
    return self.red, self.green, self.blue, self.gray
  end
  def to_a_ng
    return self.red, self.green, self.blue
  end
  alias to_a_na to_a_ng
  def to_hex
    to_a_na.collect{|i|"%02x"%i}.join ''
  end
  def to_flash
    to_hex.hex
  end
  def to_color
    Color.new *to_a
  end
  def to_tone
    Tone.new *to_a
  end
  def to_hash
    {red: red, green: green, blue: blue, grey: grey}
  end
end
# ╒╕ ♥                                                                 Font ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Font
  def to_hsh
    {
      :color       => font.color.to_color,
      #:shadow_color => font.shadow_color.to_color, YGG1x*
      :out_color    => font.out_color.to_color,
      :name         => self.name.to_a.clone,
      :size         => self.size.to_i,
      :bold         => self.bold.to_bool,
      :italic       => self.italic.to_bool,
      :shadow       => self.shadow.to_bool,
      :outline      => self.outline.to_bool
    }
  end  
  def marshal_dump
    to_hsh
  end
  def marshal_load hsh
    hsh.each_pair do |key,value|
      send(key.to_s+?=,value)
    end
  end
end
# ╒╕ ♥                                                                 Rect ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Rect
  def / n
    self.class.new(self.x/n,self.y/n,self.width/n,self.height/n)
  end
  def * n
    self.class.new(self.x*n,self.y*n,self.width*n,self.height*n)
  end
  def to_a
    return self.x, self.y, self.width, self.height
  end
  def to_va
    return self.x, self.y, self.x+self.width, self.y+self.height
  end
  def to_rect
    Rect.new *to_a
  end
  def area
    self.width*self.height
  end
  def empty?
    self.width == 0 and self.height == 0
  end
end
# ╒╕ ♥                                                                Table ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Table
  include MACL::Mixin::TableExpansion  
end
# ╒╕ ♥                                                               Bitmap ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Bitmap
  def fill sx,sy,color=Color.new(255,255,255,255)
    base_color = get_pixel sx,sy
    nodes = []
    nodes << [sx,sy]
    table = Table.new width,height 
    nx = ny = x = y =0
    while nodes.size > 0
      x,y = nodes.shift
      next unless x and y
      next if table[x,y] > 0
      set_pixel(x,y,color) 
      table[x,y] = 1
      for iy in -1..1
        for ix in -1..1
          nx,ny = x+ix,y+iy
          next if table[nx,ny].to_i > 0
          next unless get_pixel(nx,ny) == base_color
          nodes << [nx,ny] 
        end
      end
    end
  end
  def recolor! f_color,t_color=nil 
    if f_color.is_a? Color and t_color.is_a? Color 
      hsh = { f_color => t_color }
    elsif f_color.is_a? Array && t_color 
      arra = t_color.is_a? Enumerable ? t_color : [t_color]*f_color.size 
      hsh = {};f_color.each_with_index{|c,i|hsh[c]=arra[i]}
    else  
      hsh = f_color
    end  
    x,y,color = nil,nil,nil
    iterate do |x,y,color| 
      set_pixel(x,y,hsh[color]||color) 
    end
  end 
  def recolor *args,&block
    dup.recolor! *args,&block
  end
  def iterate_map 
    iterate { |x,y,color| set_pixel(x,y,yield(x,y,color)) }
  end
  def legacy_recolor color1,color2
    for y in 0...height
      for x in 0...width
        set_pixel x,y,color2 if get_pixel(x,y) == color1
      end
    end
  end 
  def palletize 
    pallete = Set.new
    iterate_do true do |x,y,color| pallete << color.to_a end
    pallete.to_a.sort.collect do |a|Color.new *a end
  end  
  def iterate return_only=false 
    x, y = nil, nil
    for y in 0...height
      for x in 0...width
        yield x,y,get_pixel(x,y) 
      end
    end   
  end 
  def draw_line point1,point2,color,weight=1
    weight = weight.max(1).to_i
    x1,y1 = point1.to_a.map! &:to_i
    x2,y2 = point2.to_a.map! &:to_i
    # Bresenham's line algorithm
    a = (y2 - y1).abs
    b = (x2 - x1).abs
    s = (a > b)
    dx = (x2 < x1) ? -1 : 1
    dy = (y2 < y1) ? -1 : 1
    if s
      c = a
      a = b
      b = c
    end
    df1 = ((b - a) << 1)
    df2 = -(a << 1)
    d = b - (a << 1)
    set_pixel_weighted(x1, y1, color, weight) 
    if(s)
      while y1 != y2
        y1 += dy
        if d < 0
          x1 += dx
          d += df1
        else
          d += df2
        end
        set_pixel_weighted(x1, y1, color, weight) 
      end
    else
      while x1 != x2
        x1 += dx
        if d < 0
          y1 += dy
          d += df1
        else
          d += df2
        end
        set_pixel_weighted(x1, y1, color, weight) 
      end
    end 
  end
  def set_pixel_weighted x,y,color,weight=1
    even = ((weight % 2) == 0) ? 1 : 0
    half = weight / 2
    for px in (x-half)..(x+half-even)
      for py in (y-half)..(y+half-even)
        self.set_pixel(px, py, color) 
      end
    end
  end
end
# ╒╕ ♥                                                               Sprite ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Sprite
  include MACL::Mixin::Surface
  def move x,y
    self.x,self.y=x,y
  end
  def to_rect
    Rect.new x,y,width,height
  end
  def to_cube
    Cube.new x,y,z,width,height,0
  end
end
# ╒╕ ■                                                         SceneManager ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module SceneManager
  def self.recall
    goto(@scene.class)
  end
end
# ╒╕ ■                                                           MapManager ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MapManager
  @@maps = {}
  def self.load_map id
    get_map(id).deep_clone
  end 
  def self.get_map id
    unless @@maps.has_key? id
      @@maps[id] = load_data("Data/Map%03d.rvdata2" % id)
      @@maps[id].do_note_scan
    end
    @@maps[id]
  end
end
# ╒╕ ♥                                                             Game_Map ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Game_Map
  def pre_load_map
  end
  def post_load_map
  end
  # // Overwrite
  def setup map_id 
    @map_id = map_id
    pre_load_map
    @map = MapManager.load_map @map_id 
    post_load_map
    @tileset_id = @map.tileset_id
    @display_x = 0
    @display_y = 0
    referesh_vehicles
    setup_events
    setup_scroll
    setup_parallax
    setup_battleback
    @need_refresh = false
  end
end
# ╒╕ ♥                                                        Game_Switches ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Game_Switches
  def on? id 
    !!self[id]
  end
  def off? id
    !self[id]
  end
  def toggle id
    self[id] = !self[id]
  end
end
MACL.init;
($imported||={}).merge!(
  'Archijust'         => 0x10001,
  'Core-Audio'        => 0x10001,
  'Core-Bitmap'       => 0x10003,
  'Core-Color'        => 0x10002,
  'Core-Font'         => 0x10001,
  'Core-Graphics'     => 0x10001,
  'Core-Rect'         => 0x10001,
  'Core-Sprite'       => 0x10001,
  'Core-Table'        => 0x10001,
  'Core-Tone'         => 0x10001,
  'MACL::ArrayTable'  => 0x10001,
  'MACL::Chitat'      => 0x10001,
  'MACL::Cube'        => 0x10002,
  'MACL::Fifo'        => 0x10002,
  'MACL::Grid'        => 0x10001,
  'MACL::Interpolate' => 0x10000,
  'MACL::Morph'       => 0x10000,
  'MACL::Parser'      => 0x11000,
  'MACL::Sequencer'   => 0x10002,
  'MACL::Sequenex'    => 0x10001,
  'Pallete'           => 0x10001,
  'Point'             => 0x10002,
  'RGSS3-MACL'        => 0x1000B,
  'Surface'           => 0x11000,
  'TableExpansion'    => 0x10001,
  'Task'              => 0x10000,
  'Tween'             => 0x11000
)
# ┌┬────────────────────────────────────────────────────────────────────────┬┐
# ╘╛ ● End of File ●                                                        ╘╛