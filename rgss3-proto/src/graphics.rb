module Graphics

  class << self

    def width
      @width ||= 544
    end

    def height
      @height ||= 416
    end

    def frame_reset
    end

    def frame_rate
      @frame_rate ||= 60
    end

    def frame_rate= n 
      @frame_rate = n.clamp(40, 120).to_i
    end

    def frame_count
      @frame_count ||= 0
    end

    def frame_count= n
      @frame_count = n.max(0).to_i
    end

    def update
      self.frame_count += 1
      sleep 1.0 / self.frame_rate
    end

    def resize_screen w, h
      @width, @height = w, h
    end

  end

end