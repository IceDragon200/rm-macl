#
# rm-macl/lib/rm-macl/core-ext/array.rb
#
require 'rm-macl/macl-core'
class Array

  ##
  # offset!(Object obj) -> Object*
  # offset!(Object obj, Boolean reverse) -> Object*
  #   Removes the first element, and pushes the (obj) unto the end
  #   if reverse
  #   Removes the last element, and pushes the (obj) unto the beginning
  def offset!(obj, reverse=false)
    reverse ? (res = self.pop; self.unshift(obj)) :
              (res = self.shift; self.push(obj))
    res
  end

  ##
  # offset(Object obj, Boolean reverse)
  #   see #offset!
  def offset(obj, reverse=false)
    dup.offset!(obj, reverse)
  end

  ##
  # pad!(newsize, padding_obj)    |
  # pad!(newsize) { padding_obj } | -> self
  #   Tries to fill the Array with padding_obj if its #size is less than the
  #   newsize.
  #   If the Array's #size is greater than the newsize, then the remaining
  #   elements in the Array are dropped to match the newsize
  def pad!(newsize, padding_obj=nil)
    self.replace(self[0, newsize]) if self.size > newsize
    self.push(block_given? ? yield : padding_obj) while self.size < newsize
    self
  end

  ##
  # pad(int newsize, padding_obj)
  # pad(int newsize) { padding_obj }
  #   see #pad!
  def pad(newsize, padding_obj=nil, &block)
    dup.pad!(newsize, padding_obj=nil, &block)
  end

  ##
  # pick! -> Object*
  #   chooses a random element in the Array, removes it and returns it
  def pick!
    delete(pick)
  end unless method_defined?(:pick!)

  ##
  # uniq_arrays!(Array<Array> groups)
  def uniq_arrays!(groups)
    all_objs, uniquesets = self, []
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
    self.replace(uniquesets)
    self
  end

  ##
  # uniq_arrays(Array<Array<Object*>> groups)
  #   see #uniq_arrays!
  def uniq_arrays(groups)
    dup.uniq_arrays!(groups)
  end

  ##
  # rotate!(int n) -> self
  def rotate!(n=1)
    return self if empty?
    concat(slice!(0, n % size))
  end unless method_defined?(:rotate!)

  ##
  # rotate(int n) -> Array<Object*>
  #   see #rotate!
  def rotate(n=1)
    dup.rotate!(n)
  end unless method_defined?(:rotate)

  def remove_n(obj, n=1)
    i = 0 ; n.times { (i = self.index(obj)) ? self.delete_at(i) : break }; self
  end

  alias :pick :sample unless method_defined?(:pick)

end
MACL.register('macl/core/array', '1.2.0')