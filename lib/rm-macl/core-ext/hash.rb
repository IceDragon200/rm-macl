#
# rm-macl/lib/rm-macl/core-ext/hash.rb
#
require 'rm-macl/macl-core'
class Hash

  ##
  # replace_key!(Hash<Object old_key, Object new_key> hash) |
  # replace_key! { |old_key| new_key }                      | -> Hash
  def replace_key!(hash=nil)
    if block_given?
      keyz = self.keys
      keyz.each { |k| self[yield(k)] = self.delete(k) }
    else
      hash.each_pair { |k, v| self[v] = self.delete(k) unless key?(k) }
    end
    return self
  end

  ##
  # replace_key -> Hash
  #   see #replace_key!
  def replace_key(hash=nil, &block)
    dup.replace_key!(hash, &block)
  end

  ##
  # remap! { |old_key, old_value| [new_key, new_value] } -> Hash
  def remap!
    key, value = nil, nil
    hsh = self.each_pair.to_a; self.clear
    hsh.each do |(key, value)|
      key, value = yield key, value
      self[key] = value
    end
    return self
  end

  ##
  # remap
  #   see #remap!
  def remap(&block)
    dup.remap!(&block)
  end

  ##
  # get_values(...Object* key) -> Array<Object*>
  def get_values(*keys)
    keys.map { |a| self[a] }
  end

  ##
  # select_key_pair(...Object* key) -> Array<Object*>
  def select_key_pair(*keys)
    Hash[keys.map { |key| [key, self[key]] }]
  end

  ##
  # enum2keys! -> Hash
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

  ##
  # enum2keys
  #   see #enum2keys!
  def enum2keys
    dup.enum2keys!
  end

end
MACL.register('macl/core/hash', '1.3.0')