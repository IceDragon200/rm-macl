=begin
 ──────────────────────────────────────────────────────────────────────────────
 RGSS3-MACL
 Version : 0.1
 ──────────────────────────────────────────────────────────────────────────────
=end
# // Standard Library
﻿#==============================================================================#
# ♥ Object (Expansion)
#==============================================================================#
# // • Created By    : IceDragon
# // • Data Created  : 01/03/2012
# // • Data Modified : 01/04/2012
# // • Version       : 1.0
#==============================================================================#
# ● Change Log
#     Unknown
#
#==============================================================================#
class Object
  def if_eql?(comp_obj,alt=nil)
    return self.eql?( comp_obj ) ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_eql? 
  def if_neql?( comp_obj, alt=nil )
    return (!self.eql?( comp_obj )) ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_neql? 
  def if_nil?( alt=nil )
    return self.nil? ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_nil?
  # // 01/31/2012
  def to_bool();!!self;end unless method_defined? :to_bool
end
#=■==========================================================================■=#
#                           // ● End of File ● //                              #
#=■==========================================================================■=#
﻿#==============================================================================#
# ■ Kernel (Expansion)
#==============================================================================#
# // • Created By    : IceDragon
# // • Data Created  : 01/14/2012
# // • Data Modified : 01/14/2012
# // • Version       : 1.0
#==============================================================================#
module Kernel
  def load_data(filename)
    obj = nil
    File.open(filename,"rb") { |f| obj = Marshal.load(f) }
    obj
  end unless method_defined? :load_data
  def save_data(obj,filename)
    File.open(filename,"wb") { |f| Marshal.dump(obj, f) }
  end unless method_defined? :save_data
  def load_data_cin(filename)
    save_data(yield,filename) unless FileTest.exist?(filename)
    load_data(filename)
  end unless method_defined? :load_data_cin
  def Boolean(obj)
    !!obj
  end unless method_defined? :Boolean
end
#=■==========================================================================■=#
#                           // ? End of File ? //                              #
#=■==========================================================================■=#
﻿#==============================================================================#
# ♥ Numeric (Expansion)
#==============================================================================#
# // • Created By    : IceDragon
# // • Data Created  : 01/03/2012
# // • Data Modified : 01/04/2012
# // • Version       : 1.0
#==============================================================================#
# ● Change Log
#     Unknown
#
#==============================================================================#
class Numeric
  def min( n )
    n < self ? n : self
  end unless method_defined? :min   
  def max( n )
    n > self ? n : self
  end unless method_defined? :max   
  def minmax( m, mx )
    self.min(m).max(mx)
  end unless method_defined? :minmax
  def clamp( min, max )
    self < min ? min : (self > max ? max : self)
  end unless method_defined? :clamp 
  def pole()
    self <=> 0
  end unless method_defined? :pole
  def pole_inv()
    -pole
  end unless method_defined? :pole_inv
end
#=■==========================================================================■=#
#                           // ● End of File ● //                              #
#=■==========================================================================■=#
﻿#==============================================================================#
# ♥ Array (Expansion)
#==============================================================================#
# // • Created By    : IceDragon
# // • Data Created  : 01/03/2012
# // • Data Modified : 01/04/2012
# // • Version       : 1.2
#==============================================================================#
# ● Change Log
#     ♣ 01/03/2012 V1.0 
#         Added
#           pick()
#           pick!()
#     ♣ 01/04/2012 V1.0 
#         Added
#           (Script Header)
#       01/29/2012 V1.1
#         Added
#           pad(n,obj=nil) { obj }
#           pad!(n,obj=nil) { obj }
#       04/18/2012
#         Added
#           uniq_arrays(groups)
#
#==============================================================================#
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
    self.delete( pick )
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
#=■==========================================================================■=#
#                           // ● End of File ● //                              #
#=■==========================================================================■=#
﻿# // 04/12/2012
# // 04/12/2012
class Hash
  def get_values(*keys);keys.collect{|a|self[a]};end
  def enum2keys
    dup.enum2keys!
  end
  def enum2keys!
    replace(inject(Hash.new) do |r,(key,value)| 
      case(key)
      when Enumerable ; key.each { |i| r[i] = value }
      else            ; r[key] = value
      end
      r
    end)
    self
  end
end 
#──────────────────────────────────────────────────────────────────────────────#
# EOF
#──────────────────────────────────────────────────────────────────────────────#