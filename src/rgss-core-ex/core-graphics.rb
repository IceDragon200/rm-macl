#-//06/04/2012
#-//06/04/2012
#-apndmacro _imported_
#-inject gen_scr_imported 'Core-Graphics', '0x10001'
#-end:
#-inject gen_module_header 'Graphics'
module Graphics
class << self

  def rect
    Rect.new(0, 0, width, height)
  end unless method_defined? :rect

  def frames_to_sec(frames)
    frames / frame_rate.to_f
  end

  def sec_to_frames(sec)
    sec * frame_rate
  end

end
end
