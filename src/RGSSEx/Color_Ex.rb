#-//06/02/2012
#-//06/02/2012
#-inject gen_class_header 'Color'
class Color
  def rgb_sym
    return :red, :green, :blue
  end
  def to_a
    return self.red, self.green, self.blue, self.alpha
  end
  def to_a_na
    return self.red, self.green, self.blue
  end
  alias to_a_ng to_a_na
  def to_hex
    to_a_na.collect{|i|"%02x"%i}.join ''
  end
  def to_flash
    to_hex.hex
  end
  def to_color
    Color.new *to_a
  end
  def to_tone
    Tone.new *to_a
  end
end