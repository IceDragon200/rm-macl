module Graphics
class << self

  attr_reader :width, :height, :frame_rate, :frame_count

  @width       = 544
  @height      = 416
  @frame_rate  = 60
  @frame_count = 0

  def frame_reset
    # Something Arcane happens here, which isn't worth replicating
  end

  def frame_rate=(n) 
    @frame_rate = (n < 1 ? 1 : (n > 120 ? 120 : n)).to_i
  end

  def frame_count=(n)
    @frame_count = n.max(0).to_i
  end

  def update
    self.frame_count += 1
    sleep 1.0 / self.frame_rate
  end

  def resize_screen(w, h)
    @width, @height = w, h
  end

end
end
