# ╒╕ ■                                                             Graphics ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class << Graphics
  def rect
    Rect.new(0,0,width,height)
  end unless method_defined? :rect 
  def frames_to_sec frames 
    frames / frame_rate.to_f
  end    
  alias frm2sec frames_to_sec
  def sec_to_frames sec
    sec * frame_rate
  end
  alias sec2frm sec_to_frames
end  