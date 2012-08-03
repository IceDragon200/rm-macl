#-skip:
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

  def load_data filename 
    obj = nil
    File.open(filename, "rb") do |f| obj = Marshal.load f end
    obj
  end unless method_defined? :load_data

  def save_data obj, filename 
    File.open(filename, "wb") do |f| Marshal.dump obj, f end; self
  end unless method_defined? :save_data

  def load_data_cin filename 
    save_data yield, filename unless FileTest.exist?(filename)
    load_data filename 
  end unless method_defined? :load_data_cin

  def Boolean obj 
    !!obj
  end unless method_defined? :Boolean
#-skip:
=begin
  def skinj_eval hsh
    raise Error_NoSkinj.new unless ($imported||={})['Skinj']
    eval_string  = hsh[:eval_string]
    binding      = hsh[:binding]
    skinj_params = hsh[:skinj_params]
    result = Skinj.skinj_str str, *skinj_params
    return eval result,binding
  end unless method_defined? :skinj_eval 
=end
#-end:
end