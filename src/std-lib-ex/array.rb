#-inject gen_class_header 'Array'
class Array

  ##
  # offset!(Object obj, Boolean reverse)
  #
  def offset!(obj, reverse=false)
    reverse ? (res = self.pop; self.unshift(obj)) : (res = self.shift; self.push(obj)); res
  end
  
  def offset(*args, &block)
    dup.offset!(*args, &block)
  end

  ##
  # pick
  #
  def pick!
    self.delete(n = pick); n
  end unless method_defined? :pick! 

  def pad *args, &block
    dup.pad! *args,&block
  end  

  def pad! newsize, obj=nil
    self.replace(self[0, newsize]) if self.size > newsize
    self.push(block_given? ? yield : obj) while self.size < newsize
    self
  end 

  def uniq_arrays *args,&block
    dup.uniq_arrays *args,&block
  end

  def uniq_arrays! groups 
    all_objs, uniquesets = self, []
    set, lastset, i, group = nil, nil, nil, nil
    while(all_objs.size > 0)
      set = all_objs.clone
      groups.each do |group|
        lastset = set
        set = set & group
        set = lastset if set.empty?
      end
      uniquesets << set
      all_objs -= set
    end
    self.replace uniquesets
    self
  end

  def rotate n=1
    dup.rotate! n 
  end unless method_defined? :rotate

  def rotate! n=1
    return self if empty?
    n %= size
    concat slice!(0, n) 
  end unless method_defined? :rotate!

  def remove_n obj, n=1
    i = 0 ; n.times { (i = self.index(obj)) ? self.delete_at(i) : break }; self
  end
  
end
