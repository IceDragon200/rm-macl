#
# rm-macl/lib/rm-macl/core-ext/match_data.rb
#
require 'rm-macl/macl-core'
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
MACL.register('macl/core/match_data', '1.1.0')