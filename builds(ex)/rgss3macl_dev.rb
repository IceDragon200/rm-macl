=begin
 ──────────────────────────────────────────────────────────────────────────────
 RGSS3-MACL
 Version : 0x10009
 Last Build: 02/07/2012 (MM/DD/YYYY) (0x10008)
 Date Built: 06/07/2012 (MM/DD/YYYY) (0x10009)
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
($imported||={})['RGSS3-MACL']=0x10009
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
  def clamp min,max
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
warn 'MACL::Parser is already imported' if ($imported||={})['MACL::Parser']
($imported||={})['MACL::Parser']=0x10002
# ╒╕ ■                                                         MACL::Parser ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL::Parser
  STRS_TRUE  = ["TRUE" ,"YES","ON" ,"T","Y"]
  STRS_FALSE = ["FALSE","NO" ,"OFF","F","N"]
  STRS_BOOL  = STRS_TRUE + STRS_FALSE
  module Regexp
    BOOL = /(?:#{STRS_BOOL.join(?|)})/i
    INT  = /\d+/
    FLT  = /\d+\.\d+/
    PRATE= /\d+%/i
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
  @data_types = {
    # // [keywords..] => proc { |s| parse_to_proper_type }
    ["string" ,"str" ]=> proc {|args|args.map!(&:to_s) },
    ["integer","int" ]=> proc {|args|args.map!(&:to_i) },
    ["boolean","bool"]=> proc {|args|args.collect!{|s|str2bool(s)}},
    ["percent","perc"]=> proc {|args|args.collect!{|s|str2prate(s)}},
    ["rate"   ,"rt"  ]=> proc {|args|args.collect!{|s|str2rate(s)}},
    ["float"  ,"flt" ]=> proc {|args|args.map!(&:to_f) },
    ["hex"]           => proc {|args|args.map!(&:hex)  }
  }
  #@data_types.merge @structs
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
warn 'Archijust is already imported' if ($imported||={})['Archijust']
($imported||={})['Archijust']=0x10001
# ╒╕ ■                                                            Archijust ╒╕
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
    end
  end
end
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
warn 'ArrayTable is already imported' if ($imported||={})['ArrayTable']
($imported||={})['ArrayTable']=0x10001
# ╒╕ ♥                                                           ArrayTable ╒╕
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
warn 'RectExpansion is already imported' if ($imported||={})['RectExpansion']
($imported||={})['RectExpansion']=0x10001
# ─┤ ● Rect.center ├──────────────────────────────────────────────────────────
def Rect.center r1,r2
  Rect.new r1.x+(r1.width-r2.width)/2,r1.y+(r1.height-r2.height)/2,r2.width,r2.height
end
# ─┤ ● Rect.fit_in ├──────────────────────────────────────────────────────────
def Rect.fit_in source,target
  w,h = source.width, source.height
  if w > h ; scale = target.width.to_f / w
  else     ; scale = target.height.to_f / h
  end
  r = source.dup;r.width,r.height=(w*scale).to_i,(h*scale).to_i;r
end
# ╒╕ ■                                           MACL::Mixin::RectExpansion ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL::Mixin::RectExpansion
  SYM_ARGS = [:x,:y,:width,:height]
  def center child_rect
    Rect.center self, child_rect
  end
  def to_a
    return self.x, self.y, self.width, self.height
  end
  def xto_a *args,&block
    (args&SYM_ARGS).collect(&(block_given? ? block : proc{|sym|self.send(sym)}))
  end
  def xto_h *args
    Hash[xto_a(*args){|sym|[sym,self.send(sym)]}]
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
  # // Destructive
  def contract! n=0,orn=0
    self.x      += n   if(orn==0 || orn==1)
    self.y      += n   if(orn==0 || orn==2)
    self.width  -= n*2 if(orn==0 || orn==1)
    self.height -= n*2 if(orn==0 || orn==2)
    self
  end
  def expand! n=0
    contract! -n
  end
  def squeeze! n=0,invert=false,orn=0
    n = n.round 0
    unless invert
      self.x += n if orn==0 || orn==1
      self.y += n if orn==0 || orn==2
    end
    self.width  -= n if orn==0 || orn==1
    self.height -= n if orn==0 || orn==2
    self
  end
  def release! n=1,invert=false,orn=0
    squeeze! -n,invert,orn
  end
  def xpush! n,orn=0
    self.x += n if orn==0 || orn==1
    self.y += n if orn==0 || orn==2
    self
  end
  def xpull! n,orn=0
    xpush! -n,orn
  end
# ╒╕ ■                                                             RectOnly ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
  module RectOnly
    def xset x=nil,y=nil,w=nil,h=nil
      x,y,w,h = x.get_values(:x,:y,:width,:height) if(x.is_a?(Hash))
      set(x||self.x,y||self.y,w||self.width,h||self.height);self
    end
    # // . x . Dup
    def contract n=1,orn=0
      dup.contract! n,orn
    end
    def expand n=1,orn=0
      dup.expand! n,orn
    end
    def squeeze n=1,invert=false,orn=0
      dup.squeeze! n,invert,orn
    end
    def release n=1,invert=false,orn=0
      dup.release! n,invert,orn
    end
    # // 03/05/2012
    def xpush n,orn=0
      dup.xpush! n,orn
    end
    def xpull n,orn=0
      dup.xpull! n,orn
    end
  end
end
# ╒╕ ■                                                       Mixin::Surface ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
warn 'Surface is already imported' if ($imported||={})['Surface']
($imported||={})['Surface']=0x10000
module MACL::Mixin::Surface
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
  def vwidth 
    self.vx + self.rwidth
  end  
  def vheight 
    self.vy + self.rheight
  end 
  def vx2
    vwidth
  end  
  def vy2
    vheight
  end  
  def vx2= n
    self.x = n - self.rwidth
  end  
  def vy2= n
    self.y = n - self.rheight
  end 
  def vset x=nil,y=nil,x2=nil,y2=nil
    self.vx = x  || self.vx
    self.vy = y  || self.vy
    self.vx2= x2 || self.vx2
    self.vy2= y2 || self.vy2
    self
  end    
  def to_a   ;return self.vx, self.vy, self.rwidth, self.rheight;end
  def to_v4a ;return self.vx, self.vy, self.vwidth, self.vheight;end
  def to_v4  ;Vector4.new *to_v4a ;end
  def to_rect;Rect.new *to_a ;end
  alias rect to_rect
  # // 02/19/2012 [
  def salign xn=-1,yn=-1,rx=0,ry=0,rwidth=Graphics.width,rheight=Graphics.height 
    case xn
    when -1; # // Do Nothing
    when 0 ; self.x = rx
    when 1 ; self.x = rx + ((rwidth - self.rwidth) / 2)
    when 2 ; self.vx2 = rwidth
    end
    case yn
    when -1; # // Do Nothing
    when 0 ; self.y = ry
    when 1 ; self.y = ry + ((rheight - self.rheight) / 2)
    when 2 ; self.vy2 = rheight
    end 
    self
  end  
  # // 02/19/2012 ]
  def offset n,anchor
    
  end
  def offset_vert! n=1.0
    self.vy += (self.rheight * n).to_i
    self
  end  
  def offset_horz! n=1.0
    self.vx += (self.rwidth * n).to_i
    self
  end 
  def offset_vert n=1.0
    dup.offset_vert!(n)
  end  
  def offset_horz n=1.0
    dup.offset_horz!(n)
  end 
  def area
    rwidth * rheight
  end  
  def perimeter
    (rwidth * 2) + (rheight * 2)
  end 
  def space_x # // Clamp Space x offset
    0
  end
  def space_y # // Clamp Space y offset
    0
  end
  def space_width
    0
  end  
  def space_height
    0
  end  
  def clamp_to_space 
    v4 = (viewport || Graphics).rect.to_v4
    cx, cw = v4.x + space_x, v4.vwidth - self.rwidth - space_width
    cy, ch = v4.y + space_y, v4.vheight - self.rheight - space_height
    self.x, self.y = self.x.clamp(cx,cw), self.y.clamp(cy,ch)
  end 
  # . x . Only works with Padded stuff
  #def _surface_padding 
  #  (respond_to?(:padding) ? padding : 0)
  #end  
  def _surface_padding 
    standard_padding
  end  
  def adjust_x4contents x,pad=_surface_padding
    x + pad
  end  
  def adjust_y4contents y,pad=_surface_padding
    y + pad
  end  
  def adjust_w4contents w,pad=_surface_padding
    w - (pad * 2)
  end  
  def adjust_h4contents h,pad=_surface_padding
    h - (pad * 2)
  end
  def adjust_xywh4contents x,y,w,h
    return [adjust_x4contents(x),adjust_y4contents(y),adjust_w4contents(w),adjust_h4contents(h)]
  end
  def adjust_rect4contents rect 
    Rect.new(*adjust_xywh4contents(*rect.to_a))
  end  
  def adjust_x4window x,pad=_surface_padding
    x - pad
  end  
  def adjust_y4window y,pad=_surface_padding
    y - pad
  end  
  def adjust_w4window w,pad=_surface_padding
    w + (pad * 2)
  end  
  def adjust_h4window h,pad=_surface_padding
    h + (pad * 2)
  end
  def adjust_xywh4window x,y,w,h
    return [adjust_x4window(x),adjust_y4window(y),adjust_w4window(w),adjust_h4window(h)]
  end
  def adjust_rect4contents rect 
    Rect.new(*adjust_xywh4window(*rect.to_a))
  end  
  # O_O
  def calc_pressure_horz n, invert=false
    return 0 if n < self.x || n > self.vwidth
    n = n - self.x
    n2 = (self.vwidth - self.x)
    n = n2 - n if invert
    n = n / n2.to_f
    return n
  end
  def calc_pressure_vert n, invert=false
    return 0 if n < self.y || n > self.vheight
    n = n - self.y
    n2 = (self.vheight - self.y)
    n = n2 - n if invert
    n = n / n2.to_f
    return n
  end
  def in_area? ax, ay
    return ax.between?(self.vx, self.vwidth) && 
      ay.between?(self.vy, self.vheight)
  end 
  def intersect? v4  
    return in_area?(v4.x, v4.y) || in_area?(v4.width,v4.height)
  end  ##
end 
# ╒╕ ♥                                                              Surface ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Surface
  include MACL::Mixin::RectExpansion
  include MACL::Mixin::RectExpansion::RectOnly
  include MACL::Mixin::Surface
  def self.area_rect *objs
    mx = objs.min { |a, b| a.x <=> b.x }
    my = objs.min { |a, b| a.y <=> b.y }
    mw = objs.max { |a, b| a.vwidth <=> b.vwidth }
    mh = objs.max { |a, b| a.vheight <=> b.vheight }
    return Vector4.v4a_to_rect( [mx.x, my.y, mw.vwidth, mh.vheight] )
  end 
  def initialize x=0,y=0,width=0,height=0
    self.x,self.y,self.width,self.height = x, y, width, height
  end  
  def set *args
    obj,=args
    a = obj.respond_to?(:to_rect) ? obj.to_rect.to_a : args
    self.x,self.y,self.width,self.height = a
  end  
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
  def vwidth
    self.width
  end  
  def vheight
    self.height
  end  
  def to_rect
    self.class.v4a_to_rect to_a
  end
  alias :old_to_s :to_s
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
# ╒╕ ♥                                                               Sprite ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Sprite
  include MACL::Mixin::Surface
end
# ╒╕ ■                                                              Pallete ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
warn 'Pallete is already imported' if ($imported||={})['Pallete']
($imported||={})['Pallete']=0x10000
module Pallete
  @sym_colors = {}
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
    get_color( @sym_colors[symbol] || 0 )
  end
  #--------------------------------------------------------------------------#
  # ● module-method :[]
  #/------------------------------------------------------------------------\#
  # ● Refer to
  #     get_color
  #\------------------------------------------------------------------------/#
  def self.[] n
    n.is_a?(Symbol) ? sym_color(n) : get_color(n)
  end
end
# ╒╕ ■                                                          MACL::Morph ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
warn 'MACL::Morph is already imported' if ($imported||={})['MACL::Morph']
($imported||={})['MACL::Morph']=0x10000
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
# ╒╕ ♥                                                          Interpolate ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
warn 'Interpolate is already imported' if ($imported||={})['Interpolate']
($imported||={})['Interpolate']=0x10000
module MACL::Interpolate
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
warn 'Grid is already imported' if ($imported||={})['Grid']
($imported||={})['Grid']=0x10001
# ╒╕ ♥                                                                 Grid ╒╕
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
warn 'Tween is already imported' if ($imported||={})['Tween']
($imported||={})['Tween']=0x10011
# ╒╕ ♥                                                                Tween ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween
  attr_reader :values
  attr_reader :start_values
  attr_reader :end_values
  attr_reader :time
  attr_reader :maxtime
  class << self
    def init
      @@_add_time = 1.0 / Graphics.frame_rate
    end
    def frames_to_tt frames
      frames * @@_add_time
    end
    alias f2tt frames_to_tt
    alias frm2sec f2tt
    def tt_to_frames tt
      Integer tt * Graphics.frame_rate
    end
    alias tt2f tt_to_frames
    alias sec2frm tt2f
    def _add_time
      @@_add_time
    end
  end
  def initialize start_values=[],end_values=[],easer=:linear,maxtime=1.0,extra_params=[]
    set_and_reset start_values, end_values, easer, maxtime, extra_params
  end
  def change_time val=nil,max=nil
    @time    = val if val
    @maxtime = max if max
  end
  def value index=0
    return @values[index]
  end
  def start_value index=0
    return @start_values[index]
  end
  def end_value index=0
    return @end_values[index]
  end
  def set start_values=[],end_values=[],easer=:linear,maxtime=1.0,extra_params=[]
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
    return Tween::EASER_SYMBOLS[@easer]
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
# ╒╕ ♥                                                           Tween::Osc ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween::Osc
  attr_reader :index
  attr_reader :tindex
  attr_reader :cycles
  def initialize *args,&block
    normal_cycle
    set *args,&block
    set_cycles -1
    reset
  end
  def reset
    @tindex = 0
    @index = 0
    @tweeners.each { |t| t.reset! }
  end
  def set_cycles n
    @cycles = n
  end
  def invert_cycle
    @inverted = true
  end
  def normal_cycle
    @inverted = false
  end
  def set svs, evs, easers=[:linear, :linear], maxtimes=[1.0,1.0]
    @tweeners = []
    for i in 0...easers.size
      args = (i % 2 == 0 ? [svs, evs] : [evs, svs]) + [easers[i], maxtimes[i%maxtimes.size]]
      @tweeners[i] = Tween.new *args
    end
    self
  end
  def total_time
    @tweeners.inject 0 do |r, t| r + t.maxtime end
  end
  def done?
    return @tindex / @tweeners.size >= @cycles unless @cycles == -1
    return false
  end
  def update
    return if done?
    if @tweeners[@index].done?
      @index = (@inverted ? @index.pred : @index.succ) % @tweeners.size
      @tindex = @tindex.succ
      @tweeners[@index].reset_time
    end
    @tweeners[@index].update
  end
  def values
    @tweeners[@index].values
  end
  def value n=0
    @tweeners[@index].value n
  end
end
# ╒╕ ♥                                                     Tween::Sequencer ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween::Sequencer
  attr_reader :index
  attr_reader :tweeners
  def initialize
    @tweeners = []
    @index = 0
  end
  def add_tween *args,&block
    @tweeners << Tween.new(*args,&block)
  end
  def reset
    @index = 0
    @tweeners.each { |t| t.reset! }
  end
  def total_time
    @tweeners.inject(0) { |r, t| r + t.maxtime }
  end
  def done?
    @tweeners.all?{|t|t.done?}
  end
  def update
    return if done?
    @index = (@inverted ? @index.pred : @index.succ) if @tweeners[@index].done?
    @tweeners[@index].update
  end
  def values
    @tweeners[@index].values
  end
  def value n=0
    @tweeners[@index].value n
  end
end
# ╒╕ ♥                                                         Tween::Easer ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween::Easer
  attr_accessor :name,:symbol
  class << self
    alias :old_new :new
    def new *args,&function
      obj = old_new *args
      # // time, start_value, change_value, current_time/elapsed_time
      @function = function
      class << obj ; define_method(:_ease,&@function) ; end
      @function = nil
      obj
    end
  end
  def initialize name=nil
    @name = name || ".Easer"
    @symbol = :__easer
  end
  def ease et, sv, ev, t, *args
    _ease et, sv, ev-sv, t, *args
  end
end
# ╒╕ ♥                                                        Tween::Easers ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween
  module Null
    In   = Easer.new "Null::In" do |t, st, ch, d| st end
    Out  = Easer.new "Null::Out"  do |t, st, ch, d| ch + st end
  end
  module Bee
    In    = Easer.new "Bee::In"  do |t, st, ch, d, b=4.0|
      (ch * t / d + st) + (-ch * Math.sin(Math.cos((b * t / d)*Math::PI)*Math::PI) / b)
    end
    Out    = Easer.new "Bee::Out"  do |t, st, ch, d, b=4.0|
      (ch * t / d + st) + (ch * Math.sin(Math.cos((b * t / d)*Math::PI)*Math::PI) / b)
    end
    InOut = Easer.new "Bee::InOut"  do |t, st, ch, d, b=4.0|
      t < d/2.0 ?
        In.ease(t*2.0, 0, ch, d, b) * 0.5 + st :
        Out.ease(t*2.0 - d, 0, ch, d, b) * 0.5 + ch * 0.5 + st
    end
  end
  # // 01/26/2012
  # // 01/26/2012
  module Modulate
    Out = Easer.new "Modulate::Out" do |t, st, ch, d, e1=:linear, e2=:linear|
      return st if ch == 0
      Tween::EASER_SYMBOLS[e1].ease(t, 0, ch, d) * (Tween::EASER_SYMBOLS[e2].ease(t, 0, ch, d) / ch) + st
    end
    In = Easer.new "Modulate::In" do |t, st, ch, d, e1=:linear, e2=:linear|
      return st if ch == 0
      Tween::EASER_SYMBOLS[e1].ease(t, 0, ch, d) * (1.0-(Tween::EASER_SYMBOLS[e2].ease(d-t, 0, ch, d) / ch)) + st
    end
    InOut = Easer.new "Modulate::InOut" do |t, st, ch, d, e1=:linear, e2=:sine_in|
      t < d/2.0 ?
        In.ease(t*2.0, 0, ch, d) * 0.5 + st :
        Out.ease(t*2.0 - d, 0, ch, d) * 0.5 + ch * 0.5 + st
    end
  end
  # // Jet
  Linear  = Easer.new "Linear"  do |t, st, ch, d| ch * t / d + st end
  module Sine
    In    = Easer.new "Sine::In"  do |t, st, ch, d|
      -ch * Math.cos(t / d * (Math::PI / 2)) + ch + st
    end
    Out   = Easer.new "Sine::Out"  do |t, st, ch, d|
      ch * Math.sin(t / d * (Math::PI / 2)) + st
    end
    InOut = Easer.new "Sine::InOut" do |t, st, ch, d|
      -ch / 2 * (Math.cos(Math::PI * t / d) - 1) + st
    end
  end
  module Circ
    In    = Easer.new "Circ::In" do |t, st, ch, d|
      -ch * (Math.sqrt(1 - (t/d) * t/d) - 1) + st rescue st
    end
    Out   = Easer.new "Circ::Out" do |t, st, ch, d|
      t = t/d - 1 ; ch * Math.sqrt(1 - t * t) + st rescue st
    end
    InOut = Easer.new "Circ::InOut" do |t, st, ch, d|
      (t /= d/2.0) < 1 ?
       -ch / 2 * (Math.sqrt(1 - t*t) - 1) + st :
        ch / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + st rescue st
    end
  end
  module Bounce
    Out    = Easer.new "Bounce::Out" do |t, st, ch, d|
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
    In    = Easer.new "Bounce::In" do |t, st, ch, d|
      ch - Out.ease(d-t, 0, ch, d) + st
    end
    InOut = Easer.new "Bounce::InOut"  do |t, st, ch, d|
      t < d/2.0 ?
        In.ease(t*2.0, 0, ch, d) * 0.5 + st :
        Out.ease(t*2.0 - d, 0, ch, d) * 0.5 + ch * 0.5 + st
    end
  end
  module Back
    In    = Easer.new "Back::In" do |t, st, ch, d, s=1.70158|
      ch * (t/=d) * t * ((s+1) * t - s) + st
    end
    Out   = Easer.new "Back::Out" do |t, st, ch, d, s=1.70158|
      ch * ((t=t/d-1) * t * ((s+1) * t + s) + 1) + st
    end
    InOut = Easer.new "Back::InOut" do |t, st, ch, d, s=1.70158|
      (t /= d/2.0) < 1 ?
        ch / 2.0 * (t * t * (((s *= (1.525)) + 1) * t - s)) + st :
        ch / 2.0 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + st
    end
  end
  module Cubic
    In    = Easer.new "Cubic::In" do |t, st, ch, d| ch * (t /= d) * t * t + st end
    Out   = Easer.new "Cubic::Out" do |t, st, ch, d|
      ch * ((t = t / d.to_f - 1) * t * t + 1) + st
    end
    InOut = Easer.new "Cubic::InOut" do |t, st, ch, d|
      (t /= d / 2.0) < 1 ?
        ch / 2.0 * t * t * t + st :
        ch / 2.0 * ((t -= 2) * t * t + 2) + st
    end
  end
  module Expo
    In    = Easer.new "Expo::In" do |t, st, ch, d|
      t == 0 ? st : ch * (2 ** (10 * (t / d.to_f - 1))) + st
    end
    Out   = Easer.new "Expo::Out" do |t, st, ch, d|
      t == d ? st + ch : ch * (-(2 ** (-10 * t / d.to_f)) + 1) + st
    end
    InOut = Easer.new "Expo::InOut" do |t, st, ch, d|
      if t == 0                ; st
      elsif t == d             ; st + ch
      elsif (t /= d / 2.0) < 1 ; ch / 2.0 * (2 ** (10 * (t - 1))) + st
      else                     ; ch / 2.0 * (-(2 ** (-10 * (t -= 1))) + 2) + st
      end
    end
  end
  module Quad
    In    = Easer.new "Quad::In" do |t, st, ch, d|
      ch * (t /= d.to_f) * t + st
    end
    Out   = Easer.new "Quad::Out" do |t, st, ch, d|
      -ch * (t /= d.to_f) * (t - 2) + st
    end
    InOut = Easer.new "Quad::InOut" do |t, st, ch, d|
      (t /= d / 2.0) < 1 ?
        ch / 2.0 * t * t + st :
        -ch / 2.0 * ((t -= 1) * (t - 2) - 1) + st
    end
  end
  module Quart
    In    = Easer.new "Quart::In" do |t, st, ch, d|
      ch * (t /= d.to_f) * t * t * t + st
    end
    Out   = Easer.new "Quart::Out" do |t, st, ch, d|
      -ch * ((t = t / d.to_f - 1) * t * t * t - 1) + st
    end
    InOut = Easer.new "Quart::InOut" do |t, st, ch, d|
      (t /= d / 2.0) < 1 ?
        ch / 2.0 * t * t * t * t + st :
        -ch / 2.0 * ((t -= 2) * t * t * t - 2) + st
    end
  end
  module Quint
    In    = Easer.new "Quint::In" do |t, st, ch, d|
      ch * (t /= d.to_f) * t * t * t * t + st
    end
    Out   = Easer.new "Quint::Out" do |t, st, ch, d|
      ch * ((t = t / d.to_f - 1) * t * t *t * t + 1) + st
    end
    InOut = Easer.new "Quint::InOut" do |t, st, ch, d|
      (t /= d / 2.0) < 1 ?
        ch / 2.0 * t * t *t * t * t + st :
        ch / 2.0 * ((t -= 2) * t * t * t * t + 2) + st
    end
  end
  module Elastic
    In    = Easer.new "Elastic::In" do |t, st, ch, d, a = 5, p = 0|
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
    Out   = Easer.new "Elastic::Out" do |t, st, ch, d, a = 5, p = 0|
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
end
class Tween
  EASERS = [
    Null::In,
    Null::Out,
    Linear,
    Sine::In,
    Sine::Out,
    Sine::InOut,
    Circ::In,
    Circ::Out,
    Circ::InOut,
    Bounce::In,
    Bounce::Out,
    Bounce::InOut,
    Back::In,
    Back::Out,
    Back::InOut,
    Cubic::In,
    Cubic::Out,
    Cubic::InOut,
    Expo::In,
    Expo::Out,
    Expo::InOut,
    Quad::In,
    Quad::Out,
    Quad::InOut,
    Quart::In,
    Quart::Out,
    Quart::InOut,
    Quint::In,
    Quint::Out,
    Quint::InOut,
    Elastic::In,
    Elastic::Out,
    Bee::In,
    Bee::Out,
    Bee::InOut,
    #Modulate::In,
    #Modulate::Out,
    #Modulate::InOut
  ]
  EASER_SYMBOLS = { }
  EASERS.each { |e|
    sym = e.name.gsub(/\:\:/i,"_").downcase.to_sym
    EASER_SYMBOLS[sym] = e
    EASER_SYMBOLS[sym].symbol = sym
  }
end
# ─┤ ● MACL.add_init ├────────────────────────────────────────────────────────
MACL.add_init :tween, Tween.method(:init)
# // 04/19/2012
# // 04/19/2012
# ╒╕ ♥                                                      MACL::Sequencer ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
warn 'MACL::Sequencer is already imported' if ($imported||={})['MACL::Sequencer']
($imported||={})['MACL::Sequencer']=0x10000
class MACL::Sequencer
  attr_accessor :index
  attr_accessor :maxcount
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
($imported||={})['Task']=0x10000
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
      reset if @called
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
    @time = @time.pred.max 0
    (@function.call; @called = true) if @time == 0 unless @called
    true
  end
  def reset
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
warn 'Fifo is already imported' if ($imported||={})['Fifo']
($imported||={})['Fifo']=0x10000
# ╒╕ ♥                                                                 Fifo ╒╕
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
      raise ArgumentError.new if args.size == 0
      if args.size == 1
        n, = args
        if n.is_a? Numeric  ; return @data[n.to_i % @size]
        elsif n.is_a? Range ; return @data[_clamp_range(n)]
        end 
      else
        raise ArgumentError.new unless args.all? {|i|i.is_a?(Numeric)}
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
        comments.map(&:parameters).flatten
      end
    end
  end
end
# ╒╕ ♥                                                           Game_Event ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Game_Event
  def comments_a
    @page.comments_a
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