#
# rm-macl/lib/rm-macl/core_ext/array.rb
#   by IceDragon
require 'rm-macl/macl-core'
class Array

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
  end unless method_defined? :pad!

  ##
  # pad(int newsize, padding_obj)
  # pad(int newsize) { padding_obj }
  #   see #pad!
  def pad(newsize, padding_obj=nil, &block)
    dup.tap { |o| o.pad!(newsize, padding_obj=nil, &block) }
  end unless method_defined? :pad

  ##
  # pick! -> Object*
  #   chooses a random element in the Array, removes it and returns it
  def pick!
    delete(pick)
  end unless method_defined? :pick!

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
    dup.tap { |o| o.uniq_arrays!(groups) }
  end

  def remove_n(obj, n=1)
    i = 0 ; n.times { (i = self.index(obj)) ? self.delete_at(i) : break }; self
  end

  ##
  # a hard combination of zip! and map!
  def zip_map!(ary)
    replace(zip(ary).map { |(x, y)| yield x, y })
  end unless method_defined? :zip_map!

  def zip_map(*args, &block)
    dup.tap { |o| o.zip_map!(*args, &block) }
  end unless method_defined? :zip_map

  alias :pick :sample unless method_defined? :pick

end
MACL.register('macl/core_ext/array', '1.5.0')