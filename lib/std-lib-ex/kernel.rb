#
# RGSS3-MACL/lib/std-lib-ex/kernel.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.2.1
module Kernel

  def load_data(filename)
    obj = nil
    File.open(filename, "rb") { |f| obj = Marshal.load(f) }
    return obj
  end unless method_defined?(:load_data)

  def save_data(obj, filename)
    File.open(filename, "wb") { |f| Marshal.dump(obj, f) }
    return self
  end unless method_defined?(:save_data)

  def load_data_cin(filename)
    save_data(yield, filename) unless FileTest.exist?(filename)
    load_data(filename)
  end unless method_defined?(:load_data_cin)

  def Boolean(obj)
    !!obj
  end unless method_defined?(:Boolean)

end
