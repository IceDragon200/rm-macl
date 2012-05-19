class Object
  def if_eql?(obj,alt=nil)
    return self.eql?(obj) ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_eql? 
  def if_neql?(obj,alt=nil)
    return (!self.eql?(obj)) ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_neql? 
  def if_nil?(alt=nil)
    return self.nil? ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_nil?
  # // 01/31/2012
  def to_bool()
    !!self
  end unless method_defined? :to_bool
end