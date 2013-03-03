#
# RGSS3-MACL/lib/std-lib-ex/matchdata.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.0.1
class MatchData

  def to_h
    hsh = {}
    return hsh if captures.empty?
    if names.empty? ; (0..10).each do |i| hsh[i] = self[i] end
    else            ; names.each do |s| hsh[s] = self[s] end
    end
    hsh
  end unless method_defined?(:to_h)

end
