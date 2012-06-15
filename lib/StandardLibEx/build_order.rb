# // Standard Library
# ╒╕ ♥                                                               Object ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Object
  def deep_clone
    Marshal.load Marshal.dump(self) 
  end
  def if_eql? obj,alt=nil
    return self.eql?(obj) ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_eql? 
  def if_neql? obj,alt=nil
    return (!self.eql?(obj)) ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_neql? 
  def if_nil? alt=nil
    return self.nil? ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_nil?
  def to_bool
    !!self
  end unless method_defined? :to_bool
end
# ╒╕ ■                                                               Kernel ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
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
# ╒╕ ♥                                                              Numeric ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Numeric
  def min(n)
    n < self ? n : self
  end unless method_defined? :min   
  def max(n)
    n > self ? n : self
  end unless method_defined? :max   
  def clamp(min, max)
    self < min ? min : (self > max ? max : self)
  end unless method_defined? :clamp 
  def pole()
    self <=> 0
  end unless method_defined? :pole
  def pole_inv()
    -pole
  end unless method_defined? :pole_inv
end
# ╒╕ ♥                                                               String ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class String
  def indent *args 
    dup.indent! *args 
  end
  def indent! n=0,s=" "
    self.replace(s*n+self)
  end
  def word_wrap chars=80
    char_count = 0
    arra = []
    result_str = ''
    self.scan(/(\S+)/i).each do |str|
      if char_count + str.size < str.chars
        char_count += str.size
        arra << str
      else
        result_str += arra.join(' ')+"\n"
        char_count,arra = 0,[]
      end  
    end
  end
  def word_wrap! chars=80
    self.replace word_wrap(chars)
  end
end
# ╒╕ ■                                                           Enumerable ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module Enumerable
  def pick
    self[rand(self.size)] 
  end unless method_defined? :pick 
  def reverse_index obj=nil
    if block_given? ; size.downto(0) do |i| return i if yield(self[i]) end
    else            ; size.downto(0) do |i| return i if self[i] == obj end
    end
    -1
  end
  def invoke meth_sym,*args,&block 
    each { |o| o.send(meth_sym,*args,&block) };self
  end
  def invoke_collect meth_sym,*args
    collect { |o| o.send(meth_sym,*args) }
  end
end
# ╒╕ ♥                                                                Array ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Array
  def pick!
    self.delete n=pick;n
  end unless method_defined? :pick! 
  def pad *args,&block
    dup.pad! *args,&block
  end  
  def pad! n,obj=nil
    self.replace(self[0,n]) if self.size > n
    self.push(block_given? ? yield : obj) while self.size < n
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
# ╒╕ ♥                                                                 Hash ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
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
# ╒╕ ♥                                                            MatchData ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class MatchData
  def to_hash
    hsh = {}
    return hsh if captures.empty? 
    if names.empty?
      (0..10).each do |i| hsh[i] = self[i] end
    else
      names.each do |s| hsh[s] = self[s] end
    end
    hsh
  end unless method_defined? :to_hash
end