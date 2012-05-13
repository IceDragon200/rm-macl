# // 05/11/2012
# // 05/11/2012
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
    ["string" ,"str" ]=> proc {|s|String(s)  },
    ["integer","int" ]=> proc {|s|Integer(s) },
    ["boolean","bool"]=> proc {|s|str2bool(s)},
    ["float"  ,"flt" ]=> proc {|s|Float(s)   },
    ["hex"]           => proc {|s|s.hex      }
  }
  str = "(a-)?(%s):(.*)" % @data_types.keys.collect{|a|"(?:"+a.join("|")+?)}.join("|")
  DTREGEX = Regexp.new(str,?i)
  @data_types.enum2keys!
  def self.parse_dtstr(dtstr)
    mtch = dtstr.match DTREGEX
    is_array, dt_type, value = mtch[1,3]
    is_array = !!is_array
    parser = @data_types[dt_type.downcase]
    #puts "is_array?[%s] dt_type[%s] value[%s]" % [is_array, dt_type, value]
    (is_array ? value.split(?,) : Array(value)).collect{|n|parser.call(n)}
  end
end