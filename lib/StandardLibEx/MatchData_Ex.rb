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