#-inject gen_class_header 'Object'
class Object

  def deep_clone
    Marshal.load Marshal.dump(self) 
  end

  def if_eql? obj, swap=nil
    return self unless self == obj
    return block_given? ? yield : swap
  end unless method_defined? :if_eql? 

  def if_neql? obj, swap=nil
    return (!self.eql?(obj)) ? (block_given? ? yield : swap) : self
  end unless method_defined? :if_neql? 

  def if_nil? swap=nil
    return self.nil? ? (block_given? ? yield : swap) : self
  end unless method_defined? :if_nil?

  def to_bool
    !!self
  end unless method_defined? :to_bool
  
end