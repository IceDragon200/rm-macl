# // 05/11/2012
# // 05/16/2012
module Notetag
  def self.str2bool(str)
    case str.upcase
    when "TRUE", "YES", "T", "Y" ; true
    when "FALSE", "NO", "F", "N" ; false
    else                         ; nil
    end
  end
  @data_types = {
    # // [keywords..] => proc { |s| parse_to_proper_type }
    ["string" ,"str" ]=> proc {|args|args.each{|s|String(s)}  },
    ["integer","int" ]=> proc {|args|args.each{|s|Integer(s)} },
    ["boolean","bool"]=> proc {|args|args.each{|s|str2bool(s)}},
    ["float"  ,"flt" ]=> proc {|args|args.each{|s|Float(s)}   },
    ["hex"]           => proc {|args|args.each{|s|s.hex}      }
  }
  @structs ||= {
  }
  @data_types.merge(@structs)
  str = "(a-)?(%s):(.*)" % @data_types.keys.collect{|a|"(?:"+a.join(?|)+?)}.join(?|)
  DTREGEX = Regexp.new(str,?i)
  @data_types.enum2keys!
  def self.parse_dtstr(dtstr,return_type=:value)
    mtch = dtstr.match DTREGEX
    raise "Malformed Data String %s" % dtstr unless mtch
    is_array, dt_type, value = mtch[1,3]
    return is_array, dt_type if return_type == :data_type
    is_array = !!is_array
    parser = @data_types[dt_type.downcase] 
    #puts "is_array?[%s] dt_type[%s] value[%s]" % [is_array, dt_type, value]
    value = parser.call(is_array ? value.split(?,) : Array(value))
    value if return_type == :value
    return is_array, dt_type, value
  end
  def self.obj_data_type(obj)
    case obj
    when Float     ; "flt"
    when Numeric   ; "int"
    when String    ; "str"
    when true,false; "bool"  
    else           ; nil
    end
  end
  def self.obj2dtstr(obj)
    if obj.is_a?(Array)
      "%s:%s" % obj.join(?,)
    else 
      type = obj_data_type(obj)
      type ? "%s:%s" % [type,obj] : nil
    end
  end
end