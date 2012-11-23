#-inject gen_class_header 'Object'
class Object

  def deep_clone
    Marshal.load(Marshal.dump(self)) 
  end

  def to_bool
    !!self
  end unless method_defined? :to_bool
  
end
