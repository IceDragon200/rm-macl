#
# RGSS3-MACL/lib/core-ext/kernel.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.2.1
module Kernel

  ##
  # load_data(String filename) -> Object*
  #   Marshal::load Object from file
  def load_data(filename)
    obj = nil
    File.open(filename, "rb") { |f| obj = Marshal.load(f) }
    return obj
  end unless method_defined?(:load_data)

  ##
  # save_data(Object* obj, String filename) -> self
  #   Marshal::dump Object to file
  def save_data(obj, filename)
    File.open(filename, "wb") { |f| Marshal.dump(obj, f) }
    return self
  end unless method_defined?(:save_data)

  ##
  # load_data_cin(String filename, Object* obj)
  # load_data_cin(String filename) { obj }
  #    If file (filename) does not exist the file is created using
  #    save_data(obj, filename) either with the supplied block or (obj)
  def load_data_cin(filename, obj=nil)
    save_data(block_given? ? yield : obj, filename) unless File.exist?(filename)
    load_data(filename)
  end unless method_defined?(:load_data_cin)

  ##
  # Boolean(obj) -> Boolean
  #   Casts obj as a Boolean (true, false)
  #   NOTE: Be wary of classes which overload the #! operator
  def Boolean(obj)
    !!obj
  end unless method_defined?(:Boolean)

  ##
  # Symbol(obj) -> Symbol
  def Symbol(obj)
    obj.to_sym
  end unless method_defined?(:Symbol)

end
