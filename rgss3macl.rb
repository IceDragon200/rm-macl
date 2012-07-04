=begin
 ──────────────────────────────────────────────────────────────────────────────
 RGSS3-MACL
 Version : 0x10008
 Last Build: 23/06/2012 (MM/DD/YYYY) (0x10007)
 Date Built: 02/07/2012 (MM/DD/YYYY) (0x10008)
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
($imported||={})['RGSS3-MACL']=0x10008
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
  def min n
    n < self ? n : self
  end unless method_defined? :min
  def max n
    n > self ? n : self
  end unless method_defined? :max
  def clamp min, max
    self < min ? min : (self > max ? max : self)
  end unless method_defined? :clamp
  def unary
    self <=> 0
  end unless method_defined? :pole
  def unary_inv
    -pole
  end unless method_defined? :pole_inv
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
    when *MACL::Parsers::STRS_TRUE
      return true
    when *MACL::Parsers::STRS_FALSE
      return false
    else
      return nil
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
# ╒╕ ■                                                          MACL::Mixin ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
#-define xNOTESCAN:
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
# ╒╕ ■                                                                  RPG ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module RPG
# ╒╕ ♥                                                             BaseItem ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
  class BaseItem
    include MACL::Mixin::BaseItem_NoteScan
  end
# ╒╕ ♥                                                                  Map ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
  class Map
    include MACL::Mixin::BaseItem_NoteScan
  end
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
  @data_types.merge @structs
  str = "(a-)?(%s):(.*)" % @data_types.keys.collect{|a|"(?:"+a.join(?|)+?)}.join(?|)
  DTREGEX = /#{str}/i
  @data_types.enum2keys!
  # // Notebox
  TAG_REGEXP = /(.+):\s*(.+)/
  # // key: value
  def self.parse_knv_str tag,types=[:nil],has_array=false
    types = Array(types)
    mtch = tag.match TAG_REGEXP
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
($imported||={})['Point']=0x10001
class Point
  def self.to_point array
    Point.new *array[0,1]
  end
  attr_accessor :x, :y
  class << self ; alias :[] :new ; end
  def initialize x=0,y=0
    @x,@y = x,y
  end
  def set x=0,y=0
    @x,@y = x,y
    self
  end
  alias old_to_s to_s
  def to_s
    "<#{self.class.name}: %s, %s>" % [self.x,self.y]
  end
  def to_a
    return @x,@y
  end
  def to_hash
    return {x: @x, y: @y}
  end
  def hash
    [@x,@y].hash
  end
  def unaries
    [@x <=> 0, @y <=> 0]
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
    def enum_commands
      sym,regex,func,params = [nil]*4
      each do |(sym,regex,func,params)|
        yield sym,regex,func,params
      end
    end
    def add_command sym,regex,params=[],&func
      @commands.push [sym,regex,func,params]
    end
    def shift_command sym,regex,params=[],&func
      @commands.unshift [sym,regex,func,params]
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
        func.call mtch
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
  @vol_rate = {
    default: 1.0,
    bgm: 1.0,
    bgs: 1.0,
    me: 1.0,
    se: 1.0
  }
  def self.vol_rate sym
    @vol_rate[sym]
  end
end
module MACL::Mixin::AudioVolume
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
  def empty?
    self.width == 0 and self.height == 0
  end
end
# ╒╕ ♥                                                              Vector4 ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Vector4 < Rect
  def rwidth
    self.width - self.x
  end
  def rheight
    self.height - self.y
  end
  def vwidth
    self.width
  end
  def vheight
    self.height
  end
  def self.v4a_to_rect v4a
    return Rect.new v4a[0], v4a[1], v4a[2]-v4a[0], v4a[3]-v4a[1]
  end
end
# ╒╕ ♥                                                                Table ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Table
  include MACL::Mixin::TableExpansion  
end
warn 'Bitmap_Ex is already imported' if ($imported||={})['Bitmap_Ex']
($imported||={})['Bitmap_Ex']=0x10002
# ╒╕ ♥                                                               Bitmap ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Bitmap
  def fill sx,sy,color=Color.new(255,255,255,255)
    base_color = get_pixel sx,sy
    nodes = []
    nodes << [sx,sy]
    table = Table.new width,height 
    nx=ny=x=y=0
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
      yield if block_given? 
    end
  end
  def recolor f_color,t_color=nil 
    if f_color.is_a? Color and t_color.is_a? Color 
      hsh = { f_color => t_color }
    elsif f_color.is_a? Array && t_color 
      arra = t_color.is_a? Enumerable ? t_color : [t_color]*f_color.size 
      hsh = {};f_color.each_with_index{|c,i|hsh[c]=arra[i]}
    else  
      hsh = f_color
    end  
    x,y,color = nil,nil,nil
    iterate_do { |x,y,color| set_pixel(x,y,hsh[color]||color) }
  end 
  def iterate_map 
    iterate_do { |x,y,color| set_pixel(x,y,yield(x,y,color)) }
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
  def iterate_do return_only=false 
    x, y = nil, nil
    for y in 0...height
      for x in 0...width
        yield x,y,get_pixel(x,y) 
      end
    end   
  end 
  def draw_line point1,point2,color,weight
    x1,y1 = point1.to_a
    x2,y2 = point2.to_a
    dx = x2 - x1
    dy = y2 - y1
    sx = x1 < x2 ? 1 : -1
    sy = y1 < y2 ? 1 : -1
    err= (dx-dy).to_f
    e2 = 0
    loop do
      set_pixel_weighted x1,x2,color,weight 
      break if x1 == x2 and y1 == y2 
      e2 = 2*err
      if e2 > -dy 
        err = err - dy
        x1  = x1 + sx  
      end
      if e2 < dx 
        err = err + dx
        y1  = y1 + sy 
      end
    end  
  end
  def set_pixel_weighted x,y,color,weight=1
    weight.times do |i| set_pixel(x,y+i,color) end
  end
end
# ╒╕ ♥                                                               Sprite ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Sprite
  def to_rect
    Rect.new x,y,width,height
  end
  def to_cube
    Cube.new x,y,z,width,height,0
  end
end
# ╒╕ ♥                                                     RPG::Event::Page ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module RPG
  class Event
    class Page
      COMMENT_CODES = [108,408]
      def select_commands *codes
        @list.select do |c| codes.include?(c.code) end
      end
      def comments
        select_commands *COMMENT_CODES
      end
      def comments_a
        comments.map!(&:parameters).flatten!
      end
    end
  end
end
# ╒╕ ♥                                                           Game_Event ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Game_Event
  def comment_a
    @page.comment_a
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
MACL.run_init;
# ┌┬────────────────────────────────────────────────────────────────────────┬┐
# ╘╛ ● End of File ●                                                        ╘╛