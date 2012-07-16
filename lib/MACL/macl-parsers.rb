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