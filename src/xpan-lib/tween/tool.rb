#
# src/xpan-lib/tween/tool.rb
# vr 0.1
module MACL::Tween::Tool

  def self.flipflop_reset(tween)
    tween.start_values, tween.end_values = tween.end_values, tween.start_values
    tween.reset_time

    return true
  end

end
