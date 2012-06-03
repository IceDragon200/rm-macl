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