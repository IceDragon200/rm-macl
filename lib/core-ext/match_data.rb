#
# RGSS3-MACL/lib/core-ext/matchdata.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.0.1
class MatchData

  ##
  # to_h -> Hash
  def to_h
    hsh = {}
    return hsh if captures.empty?
    if names.empty? then a = to_a; Hash[(0...a.size).to_a.zip(a)]
    else                 names.each do |s| hsh[s] = self[s] end
    end
    hsh
  end unless method_defined?(:to_h)

end
