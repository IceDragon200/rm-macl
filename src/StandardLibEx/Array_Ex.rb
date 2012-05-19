class Array
  #--------------------------------------------------------------------------#
  # ● new-method :pick
  #/------------------------------------------------------------------------\#
  # ● Return
  #     Random Element From Array
  #\------------------------------------------------------------------------/#
  def pick()
    self[rand(self.size)] 
  end unless method_defined? :pick 
  #--------------------------------------------------------------------------#
  # ● new-method :pick!
  #/------------------------------------------------------------------------\#
  # ● Explanation
  #     Chooses a random element, removes from the array and returns it
  #\------------------------------------------------------------------------/#
  def pick!()
    self.delete(pick)
  end unless method_defined? :pick! 
  # // 01/29/2012
  #--------------------------------------------------------------------------#
  # ● new-method :pad
  #/------------------------------------------------------------------------\#
  # ● Explanation
  #     Adds (obj) or pops elements from the array until its size is == n
  #\------------------------------------------------------------------------/#
  def pad(*args,&block)
    dup.pad!(*args,&block)
  end  
  def pad!(n,obj=nil)
    self.replace(self[0,n]) if(self.size > n)
    self.push(block_given?() ? yield : obj) while(self.size < n)
    self
  end 
  # // 04/18/2012
  #--------------------------------------------------------------------------#
  # ● new-method :uniq_arrays
  #/------------------------------------------------------------------------\#
  # ● Explanation
  #     Creates uniq arrays from a group of arrays using the elements of self
  #     ! will destroy the current array and replace it with the unique sets
  #\------------------------------------------------------------------------/#
  def uniq_arrays(*args,&block)
    dup.uniq_arrays(*args,&block)
  end
  def uniq_arrays!(groups) 
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
  # // 05/02/2012
  def remove_this(obj,n=1)
    n.times { (i = self.index(obj)) ? self.delete_at(i) : break }; self
  end
end