#
# RGSS3-MACL/lib/std-lib-ex/hash.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.1.0
class Hash

  def replace_key!(hash)
    k, v = nil, nil
    if block_given?
      keyz = self.keys
      keyz.each do |k| v = yield k; self[v] = self.delete k end
    else
      hash.each_pair do |k,v| self[v] = self.delete k end
    end
    return self
  end

  def replace_key(*args, &block)
    dup.replace_key!(*args, &block)
  end

  def remap!
    key, value = nil, nil
    hsh = self.each_pair.to_a; self.clear
    hsh.each do |(key, value)|
      key, value = yield key, value; self[key] = value
    end
    return self
  end

  def remap(&block)
    dup.remap!(&block)
  end

  def get_values(*keys)
    keys.map { |a| self[a] }
  end

  def select_key_pair(*keys)
    Hash[keys.map { |key| [key, self[key]] }]
  end

  def enum2keys!
    r, key, value = nil, nil, nil
    replace(inject(Hash.new) do |r, (key, value)|
      case key
      when Enumerable ; key.each { |i| r[i] = value }
      else            ; r[key] = value
      end
      r
    end)
    return self
  end

  def enum2keys
    dup.enum2keys!
  end

end
