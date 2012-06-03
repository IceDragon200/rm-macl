=begin
 ──────────────────────────────────────────────────────────────────────────────
 RGSS3-MACL
 Version : 1.0
 Date Built: 06/02/2012 (MM/DD/YYYY)
 ──────────────────────────────────────────────────────────────────────────────
 ■ Module
 ♥ Class
 
 Parameter, Return : Help
   -Help       Ruby Object
     <self>    (Parent Object)
     <Object>  (Varied Object)
     N[]       (Array of N Object)
     String    String
     Boolean   (TrueClass or FalseClass)
     Numeric   (Integer,Bignum,Float)
     Integer   Integer
     Float     Float
     Array     Array
     Hash      Hash
     Symbol    Symbol
────────────────────────────────────────────────────────────────────────────────
Standard Library
────────────────────────────────────────────────────────────────────────────────
  ♥ Object
    deep_clone 
      ● Return
          <self>
    if_eql?(obj,alt=nil), if_neql?(obj,alt=nil)
      ● Parameters 
          <Object> obj, alt
      ● Return
          if block_given:
            <Object> from yield
          else:
            alt from Parameters
    if_nil?(alt=nil)
      ● Parameters 
          <Object> alt
      ● Return
          if block_given:
            <Object> from yield
          else:
            alt from Parameters
    to_bool 
      ● Return
          Boolean
  ■ Kernel
    load_data(filename) [None-RGSS2/3]
      ● Parameters 
          String filename
      ● Return
          <Object>
    save_data(obj,filename) [None-RGSS2/3]
      ● Parameters 
          <Object> obj
          String filename
      ● Return
          <Object>
    load_data_cin(filename) { obj }
      ● Parameters 
          String filename
      ● Return
          <Object>
    Boolean(obj)
      ● Parameters 
          Object obj 
      ● Return
          Boolean 
  ♥ Numeric
    min(n), max(n)
      ● Parameters 
          Numeric n
      ● Return
          Numeric
    clamp(min,max)
      ● Parameters 
          Numeric min, max
      ● Return
          Numeric
    pole
      ● Return
          Numeric{0,1}
    pole_inv
      ● Return
          not pole
  ■ Enumerable
    pick
      ● Return
          <Object>
    reverse_index(obj), reverse_index { |obj| Compare }
      ● Parameters 
          <Object> obj
      ● Return
          Integer
    invoke(meth_sym,*args)
      ● Parameters 
          Symbol     meth_sym
          <Object>[] args
      ● Return
          <self>
    invoke_collect(meth_sym,*args)
      ● Parameters 
          Symbol     meth_sym
          <Object>[] args
      ● Return
          <Object>[]
  ♥ Array
    pick!
      ● Return
          <Object>
    pad(n, obj), pad!(n, obj), pad(n) { obj }, pad!(n) { obj }
      ● Parameters 
          <Object> obj
      ● Return
          <self>
    uniq_arrays(groups), uniq_arrays!(groups)
      ● Parameters 
          <Object>[] groups
      ● Return
          Array or <self>
    remove_this(obj,n)
      ● Parameters 
          <Object> obj
          Integer n
      ● Return
          <self>
  ♥ Hash
    get_values(*keys)
      ● Parameters 
          <Object>[] keys
      ● Return
          <Object>[]
    enum2keys,enum2keys!
      ● Return
          Hash or <self>
────────────────────────────────────────────────────────────────────────────────
eXpansion Library
────────────────────────────────────────────────────────────────────────────────
  ♥ Point
    .new(x,y), .[x,y]
      ● Parameters 
          Integer x, y
      ● Return
          Point
    set
      ● Parameters 
          Integer x, y
      ● Return
          <self>
    to_a
      ● Return
          Numeric[x, y]
    to_s
      ● Return
          String
    to_hsh
      ● Return
          Hash[:x,:y]
    hash
      ● Return
          Integer
  ♥ Chitat
    .new(open_tag,close_tag)
      ● Parameters 
          Regexp open_tag, close_tag
      ● Return
          Chitat
    mk_and_set_tag(str)      
      ● Parameters 
          String str
      ● Return
          <self>
    parse_str(str)
      ● Parameters 
          String str
      ● Return
          String[]
────────────────────────────────────────────────────────────────────────────────
RGSSEx Expansion
────────────────────────────────────────────────────────────────────────────────
  ♥ Color, ♥ Tone
    to_a
      ● Return
          Numeric[red, green, blue, alpha]
    to_a_na, to_a_ng
      ● Return
          Numeric[red, green, blue]
    to_hex
      ● Return
          String hex
    to_flash
      ● Return
          Integer
    to_color
      ● Return
          Color
    to_tone
      ● Return
          Tone
    rgb_sym
      ● Return
          Symbol[:red, :green, :blue]
  ♥ Font
    to_hsh, marshal_dump
      ● Return
          Hash[:color, :out_color, :name, :size, :bold, :italic, :shadow, :outline]
    marshal_load(font_hash)
      ● Parameters 
          Hash font_hash
  ♥ Rect
    to_a
      ● Return
          Numeric[x, y, width, height]
    to_va
      ● Return
          Numeric[x, y, vwidth, vheight]
    to_rect
      ● Return
          Rect
  ♥ RPG::BaseItem
  ♥ RPG::Event::Page
    select_commands(*codes)
      ● Parameters 
          Integer[]
      ● Return
          RPG::Event::Page[]
    comments
      ● Return
          RPG::EventCommand[]
    comments_a
      ● Return
          String[]
  ♥ Game_Switches
    on?(id)
      ● Parameters 
          Integer id
      ● Return
          Boolean
    off?(id)
      ● Parameters 
          Integer id
      ● Return
          Boolean      
    toggle(id)
      ● Parameters 
          Integer id
      ● Return
          Boolean
=end
($imported||={})['RGSS3-MACL']=0x10000
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
# ╒╕ ■                                                               Kernel ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module Kernel
  def load_data(filename)
    obj = nil
    File.open(filename,"rb") { |f| obj = Marshal.load(f) }
    obj
  end unless method_defined? :load_data
  def save_data(obj,filename)
    File.open(filename,"wb") { |f| Marshal.dump(obj, f) }
  end unless method_defined? :save_data
  def load_data_cin(filename)
    save_data(yield,filename) unless FileTest.exist?(filename)
    load_data(filename)
  end unless method_defined? :load_data_cin
  def Boolean(obj)
    !!obj
  end unless method_defined? :Boolean
end
# ╒╕ ♥                                                              Numeric ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Numeric
  def min(n)
    n < self ? n : self
  end unless method_defined? :min   
  def max(n)
    n > self ? n : self
  end unless method_defined? :max   
  def clamp(min, max)
    self < min ? min : (self > max ? max : self)
  end unless method_defined? :clamp 
  def pole()
    self <=> 0
  end unless method_defined? :pole
  def pole_inv()
    -pole
  end unless method_defined? :pole_inv
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
  def invoke meth_sym,*args 
    each { |o| o.send(meth_sym,*args) };self
  end
  def invoke_collect meth_sym,*args
    collect { |o| o.send(meth_sym,*args) }
  end
end
# ╒╕ ♥                                                                Array ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Array
  def pick!
    self.delete(n=pick);n
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
    n.times { (i = self.index(obj)) ? self.delete_at(i) : break }; self
  end
end
# ╒╕ ♥                                                                 Hash ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Hash
  def get_values(*keys);keys.collect{|a|self[a]};end
  def enum2keys
    dup.enum2keys!
  end
  def enum2keys!
    replace(inject(Hash.new) do |r,(key,value)| 
      case(key)
      when Enumerable ; key.each { |i| r[i] = value }
      else            ; r[key] = value
      end
      r
    end)
    self
  end
end
# ╒╕ ■                                                                 MACL ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
end
# ╒╕ ■                                                          MACL::Mixin ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL::Mixin
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
# ╒╕ ♥                                                        RPG::BaseItem ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class RPG::BaseItem
  include MACL::Mixin::BaseItem_NoteScan
end
# ╒╕ ♥                                                             RPG::Map ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class RPG::Map
  include MACL::Mixin::BaseItem_NoteScan
end
# ╒╕ ■                                                                 MACL ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class << MACL
  def mk_null_str(size=256)
    string = "\0" * size
  end
  @w32_funcs = {
    'GPPSA' => Win32API.new('kernel32', 'GetPrivateProfileStringA', 'pppplp', 'l'),
    'GetClientRect' => Win32API.new('user32', 'GetClientRect', 'lp', 'i'),
    #'GetWindowRect' => Win32API.new('user32', 'GetWindowRect', 'lp', 'i'),
    'FindWindowEx'  => Win32API.new('user32','FindWindowEx','llpp','l')
  }
  def get_client
    string = mk_null_str(256)
    @w32_funcs['GPPSA'].call('Game','Title','',string,255,".\\Game.ini")
    @w32_funcs['FindWindowEx'].call(0, 0, nil, string.delete!("\0"))
  end
  private :get_client
  def client_rect
    rect = [0, 0, 0, 0].pack('l4')
    @w32_funcs['GetClientRect'].call(client, rect)
    Rect.new(*rect.unpack('l4').map!(&:to_i))
  end
  def client
    @client ||= get_client
  end
end
# ╒╕ ■                                                        MACL::Parsers ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL::Parsers
  STRS_TRUE  = ["TRUE","YES","ON","T","Y"]
  STRS_FALSE = ["FALSE","NO","OFF","F","N"]
  STRS_BOOL  = STRS_TRUE + STRS_FALSE
  module Regexp
    BOOL = /(?:#{STRS_BOOL.join(?|)})/i
    INT = /\d+/
    FLT = /\d+\.\d+/
  end
  # // Converters
  def self.obj2str(*objs)
    return *objs.collect do |obj| String(obj) end
  end
  def self.str2bool(*strs)
    return *strs.collect do |str|
      case str.upcase
      when *STRS_TRUE  ; true
      when *STRS_FALSE ; false
      else             ; nil
      end
    end  
  end
  def self.str2int(*strs)
    return *strs.collect do |str| Integer(str) end
  end
  def self.str2flt(*strs)
    return *strs.collect do |str| Float(str) end
  end
  def self.str2int_a(str)
    str.scan(/\d+/).map!(&:to_i)
  end
  def self.str2array(str)
    str.split(?,)
  end
  def self.str2obj(str,type=:nil)
    case type
    when :int, :integer ; str2int(str)
    when :flt, :float   ; str2flt(str)
    when :bool,:boolean ; str2bool(str)
    when :str, :string  ; str.to_s
    else # // Guess type
      if str =~ Regexp::FLT
        str2flt(str)
      elsif str =~ Regexp::INT
        str2int(str)
      elsif str =~ Regexp::BOOL_REGEX
        str2bool(str)
      else # // String
        str.to_s
      end
    end
  end
  # // Get dtstr
  def self.obj_data_type(obj)
    case obj
    when Float     ; "flt" 
    when Numeric   ; "int" # // Float is also Numeric type
    when String    ; "str"
    when true,false; "bool"  
    else           ; nil
    end
  end
  # // 100 => int:100, "stuff"=>str:stuff
  def self.obj2dtstr(obj)
    if obj.is_a?(Array)
      "%s:%s" % [obj_data_type(obj.first),obj.join(?,)]
    else 
      type = obj_data_type(obj)
      type ? "%s:%s" % [type,obj] : nil
    end
  end
  @data_types = {
    # // [keywords..] => proc { |s| parse_to_proper_type }
    ["string" ,"str" ]=> proc {|args|args.map!(&:to_s) },
    ["integer","int" ]=> proc {|args|args.map!(&:to_i) },
    ["boolean","bool"]=> proc {|args|args.collect!{|s|str2bool(s)}},
    ["float"  ,"flt" ]=> proc {|args|args.map!(&:to_f) },
    ["hex"]           => proc {|args|args.map!(&:hex)  }
  }
  @structs ||= {
  }
  @data_types.merge(@structs)
  str = "(a-)?(%s):(.*)" % @data_types.keys.collect{|a|"(?:"+a.join(?|)+?)}.join(?|)
  DTREGEX = /#{str}/i
  @data_types.enum2keys!
  # // Notebox
  TAG_REGEXP = /(.+):\s*(.+)/
  # // key: value
  def self.parse_knv_str(tag,types=[:nil],has_array=false)
    types = Array(types)
    mtch = tag.match TAG_REGEXP
    return nil unless mtch
    key,value = mtch[1,2]
    values = (has_array ? value.split(?,) : Array(value))
    values = values.each_with_index.to_a
    values.collect!{|(n,index)|value2obj(n,types[index]||:nil)}
    return key, values
  end
  # // Chitat Main 
  # // str:Stuff, int:2, flt:0.2, bool:TRUE
  def self.parse_dtstr(dtstr,return_type=:value)
    mtch = dtstr.match DTREGEX
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
# // Xpansion Library
# ╒╕ ♥                                                                Point ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
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
    attr_reader :sym,:match_data
    def initialize sym,match_data
      @sym,@match_data = sym,match_data
    end
    def param(i)
      @match_data[i]
    end
    def params
      @match_data.to_a
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
    arra.each { |a| a.collect!{|s|mk_tag(s)}.compact! }
    arra.reject! {|a|a and a.empty?}
  end
end
#// RGGSEx
# ╒╕ ♥                                                                Color ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Color
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
  def to_a
    return self.x, self.y, self.width, self.height
  end
  def to_va
    return self.x, self.y, self.x+self.width, self.y+self.height
  end
  def to_rect
    Rect.new *to_a
  end
end
# ╒╕ ♥                                                     RPG::Event::Page ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class RPG::Event::Page
  COMMENT_CODES = [108,408]
  def select_commands(*codes)
    @list.select{|c|codes.include?(c.code)}
  end
  def comments
    select_commands *COMMENT_CODES
  end
  def comments_a
    comments.map!(&:parameters).flatten!
  end
end
# ╒╕ ♥                                                           Game_Event ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Game_Event
  def comment_a
    @page.comment_a
  end
end
# ╒╕ ■                                                           MapManager ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MapManager
  @@maps = {}
  def self.load id
    get_map(id).deep_clone
  end 
  def self.get_map id
    unless @@maps.has_key? id
      @@maps[id] = load_data("Data/Map%03d.rvdata2" % id)
      @@maps[id].note_scan
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
  def setup(map_id)
    @map_id = map_id
    pre_load_map
    @map = MapManager.load(@map_id)
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
  def on?(id)
    !!self[id]
  end
  def off?(id)
    !self[id]
  end
  def toggle(id)
    self[id] = !self[id]
  end
end
# ┌┬────────────────────────────────────────────────────────────────────────┬┐
# ╘╛ ● End of File ●                                                        ╘╛