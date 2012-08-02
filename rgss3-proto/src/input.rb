module Input

  A, B, C, X, Y, Z, L, R = [0] * 8
  CTRL, ALT, SHIFT = [0] * 3

  @@key_times = {}

  SYM2KEY = {
    :LEFT  => Gosu::KbLeft,
    :RIGHT => Gosu::KbRight,
    :UP    => Gosu::KbUp,
    :DOWN  => Gosu::KbDown,
    :A     => Gosu::KbA,
    :B     => Gosu::KbS,
    :C     => Gosu::KbD,
    :X     => Gosu::KbZ,
    :Y     => Gosu::KbX,
    :Z     => Gosu::KbC,
    :SHIFT => Gosu::KbRightShift,
    :CTRL  => Gosu::KbRightControl,
    :ALT   => Gosu::KbRightAlt,
    :F5    => Gosu::KbF5,
    :F6    => Gosu::KbF6,
    :F7    => Gosu::KbF7,
    :F8    => Gosu::KbF8,
    :F9    => Gosu::KbF9
  }

  class << self

    def button_down?(n)
      return false unless Main.window
      return Main.window.button_down?(n)
    end

    def update
      dropped_keys = []
      @@key_times.each_pair do |k, v|
        n = if button_down?(k)
          @@key_times[k] += 1 
        else
          @@key_times[k] = 0
        end
        dropped_keys << k if n <= 0
      end
      dropped_keys.each do |i| @@key_times.delete(i) end      
    end

    def key_test id
      @@key_times[id] ||= 1 if button_down?(id)
    end

    def sym2key sym
      return sym if sym.is_a?(Numeric)
      id = SYM2KEY[sym]
      raise "Unsupported key #{sym}" unless id
      id 
    end

    def _down(id)
      key_test(id)
      @@key_times[id] || 0
    end

    def trigger?(n)
      _down(sym2key(n)||n) == 1
    end

    def repeat?(key)
      n = _down(sym2key(key)||key)
      n == 1 or n % 23 == 0
    end

    def press?(n)
      _down(sym2key(n)||n) >= 1
    end

    def dir4
      return 2 if press?(:DOWN)
      return 8 if press?(:UP)
      return 4 if press?(:LEFT)
      return 6 if press?(:RIGHT)
      return 0
    end

    def dir8
      return 1 if press?(:DOWN) and press?(:LEFT)
      return 3 if press?(:DOWN) and press?(:RIGHT)
      return 7 if press?(:UP) and press?(:LEFT)
      return 9 if press?(:UP) and press?(:RIGHT)
      return dir4
    end

  end  

end