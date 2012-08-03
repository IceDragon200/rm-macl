#-inject gen_module_header 'Enumerable'
module Enumerable

  def pick
    self[rand(self.size)] 
  end unless method_defined? :pick 

  def reverse_index obj=nil
    if block_given? ; size.downto(0) do |i| return i if yield(self[i]) end
    else            ; size.downto(0) do |i| return i if self[i] == obj end
    end
    nil
  end
=begin
  def invoke meth_sym, *args, &block 
    each { |o| o.send(meth_sym,*args,&block) };self
  end

  def invoke_collect meth_sym, *args, &block
    collect { |o| o.send(meth_sym,*args,&block) }
  end
=end
end