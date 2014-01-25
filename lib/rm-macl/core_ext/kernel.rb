#
# rm-macl/lib/rm-macl/core_ext/kernel.rb
#   by IceDragon
require 'rm-macl/macl-core'
module Kernel

  ##
  # load_data(String filename)
  #   Marshal::load Object from file
  # @return [Object]
  def load_data(filename)
    obj = nil
    File.open(filename, "rb") { |f| obj = Marshal.load(f) }
    return obj
  end unless method_defined? :load_data

  ##
  # save_data(Object* obj, String filename)
  #   Marshal::dump Object to file
  # @return [Void]
  def save_data(obj, filename)
    File.open(filename, "wb") { |f| Marshal.dump(obj, f) }
  end unless method_defined? :save_data

  ##
  # load_data_cin(String filename, Object* obj)
  # load_data_cin(String filename) { obj }
  #    If file (filename) does not exist the file is created using
  #    save_data(obj, filename) either with the supplied block or (obj)
  # @return [Object]
  def load_data_cin(filename, obj=nil)
    save_data(block_given? ? yield : obj, filename) unless File.exist?(filename)
    load_data(filename)
  end unless method_defined? :load_data_cin

  ##
  # Boolean(obj) -> Boolean
  #   Casts obj as a Boolean (true, false)
  #   NOTE: Be wary of classes which overload the #! operator
  # @return [Boolean]
  def Boolean(obj)
    !!obj
  end unless method_defined? :Boolean

  ##
  # Symbol(obj)
  # @return [Symbol]
  def Symbol(obj)
    obj.to_sym
  end unless method_defined? :Symbol

  ##
  # Range(obj)
  # @return [Range]
  def Range(obj)
    case obj
    when Array
      return obj.first..obj.last
    when Range
      return obj
    else
      obj.to_range
    end
  end unless method_defined? :Range

end
MACL.register('macl/core_ext/kernel', '1.3.0')