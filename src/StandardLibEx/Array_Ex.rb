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
  def invoke meth_sym,*args 
    each { |o| o.send(meth_sym,*args) };self
  end
  def collect_invoke meth_sym,*args
    collect { |o| o.send(meth_sym,*args) }
  end
end
#-inject gen_class_header 'Array'
class Array
  def pad *args,&block
    dup.pad! *args,&block
  end  
  def pad! n,obj=nil
    self.replace(self[0,n]) if self.size > n
    self.push(block_given?() ? yield : obj) while(self.size < n)
    self
  end 
  def uniq_arrays *args,&block
    dup.uniq_arrays *args,&block
  end
  def uniq_arrays! groups 
    all_objs,uniquesets = self, []
    set, lastset, i, group = nil, nil, nil, nil
    while(all_objs.size > 0)
      set = all_objs.clone
      for i in 0...groups.size
        group = groups[i]
        lastset = set
        set = set & group
        set = lastset if(set.empty?())
      end
      uniquesets << set
      all_objs -= set
    end
    self.replace(uniquesets)
    self
  end
  def pick!
    self.delete(n=pick);n
  end unless method_defined? :pick! 
  def rotate n=1
    dup.rotate! n 
  end unless method_defined? :rotate
  def rotate! n=1
    return self if empty?
    n %= size
    concat(slice!(0,n))
  end unless method_defined? :rotate!
  def remove_this obj,n=1
    n.times { (i = self.index(obj)) ? self.delete_at(i) : break }; self
  end
end