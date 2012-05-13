# // 05/12/2012
# // 05/12/2012
module Notebox
  # // Only needed the bool one, but just for bug fixing, I added int and flt
  BOOLS_TRUE  =
  BOOLS_FALSE =
  def self.str2bool(str)
    case str.upcase
    when "TRUE", "YES", "T", "Y" ; true
    when "FALSE", "NO", "F", "N" ; false
    else                         ; nil
    end
  end
  def self.str2int(str)
    Integer(str)
  end
  def self.str2flt(str)
    Float(str)
  end
  def self.value2obj(str,type=:nil)
    case type
    when :int, :integer ; str2int(str)
    when :flt, :float   ; str2flt(str)
    when :bool,:boolean ; str2bool(str)
    when :str, :string  ; str.to_s
    else # // Guess type
      if str =~ /\d+\.\d+/
        str2flt(str)
      elsif str =~ /\d+/
        str2int(str)
      elsif str =~ /(?:TRUE|YES|FALSE|NO|T|Y|F|N)/i
        str2bool(str)
      else # // String
        str.to_s
      end
    end
  end
  TAG_REGEXP = /(.+):[ ]*(.+)/
  def self.parse_dtstr(tag,types=[:nil],has_array=false)
    types = Array(types)
    mtch = tag.match TAG_REGEXP
    return nil unless mtch
    key,value = mtch[1,2]
    values = (has_array ? value.split(?,) : Array(value)).each_with_index.to_a.collect{|(n,index)|value2obj(n,types[index]||:nil)}
    return key, values
  end
end