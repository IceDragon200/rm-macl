#
# RGSS3-MACL/lib/rgss-core-ex/graphics.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 01/04/2013
# vr 1.1.1
module Graphics
class << self

  def rect
    Rect.new(0, 0, width, height)
  end unless method_defined?(:rect)

  def frames_to_sec(frames)
    return frames / frame_rate.to_f
  end unless method_defined?(:frames_to_sec)

  def sec_to_frames(sec)
    return (sec * frame_rate).to_i
  end unless method_defined?(:sec_to_frames)

end
end
