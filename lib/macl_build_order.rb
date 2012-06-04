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
  def self.Singulize array
    return array.size == 1 ? array[0] : array
  end
  # // Converters
  def self.obj2str *objs
    Singulize(objs.collect do |obj| String(obj) end)
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
    Singulize(strs.collect do |str| Integer(str) end)
  end
  def self.str2flt *strs
    Singulize(strs.collect do |str| Float(str) end)
  end
  def self.str2int_a str
    str.scan(/\d+/).map!(&:to_i)
  end
  def self.str2array str
    str.split(?,)
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