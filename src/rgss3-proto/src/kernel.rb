module Kernel

  def load_data(filename)
    result = nil
    File.open(filename, 'rb') do |f| result = Marshal.load(f.read) end
    result
  end unless method_defined? :load_data

  def save_data(obj, filename)
    File.open(filename, 'wb') do |f| f.write(Marshal.dump(obj)) end
  end unless method_defined? :save_data

end
