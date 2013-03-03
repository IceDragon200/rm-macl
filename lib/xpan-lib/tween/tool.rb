#
# RGSS3-MACL/lib/xpan-lib/tween/tool.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.0.0
require File.join(File.dirname(__FILE__), 'tween')

module MACL
class Tween
module Tool

  def self.flipflop_reset(tween)
    tween.start_values, tween.end_values = tween.end_values, tween.start_values
    tween.reset_time

    return true
  end

end
end
end
