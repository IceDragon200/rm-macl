﻿#-skip:
=begin
#-inject gen_class_header 'Error_NoSkinj'
class Error_NoSkinj < StandardError

  def message
    'Skinj is not installed!'
  end

end
=end
#-end:
#-inject gen_module_header 'Kernel'
module Kernel

  def load_data(filename)
    obj = nil
    File.open(filename, "rb") do |f| obj = Marshal.load(f) end
    obj
  end unless method_defined? :load_data

  def save_data(obj, filename)
    File.open(filename, "wb") do |f| Marshal.dump(obj, f) end; self
  end unless method_defined? :save_data

  def load_data_cin(filename)
    save_data yield, filename unless FileTest.exist?(filename)
    load_data filename
  end unless method_defined? :load_data_cin

  def Boolean(obj)
    !!obj
  end unless method_defined? :Boolean

  def relative_path
    return File.dirname(caller[0])
  end

end
