#-//06/02/2012
#-//06/02/2012
#-apndmacro _imported_
#-inject gen_scr_imported 'Core-Color', '0x10002'
#-end:
#-inject gen_class_header 'Color'
class Color

  # // Gotta find a better way ;x
  #-// red, green, blue = ('%06x' % int).split(/(\w{2})/).reject(&:empty?).map(&:hex)     
  def self.hex(int) 
    raise(OutOfRange, int) if int < 0
    d1    = 256 ** 2
    red   = int / d1
    sub1  = red * d1
    green = (int - sub1) / 256
    sub2  = green * 256
    blue  = (int - sub1 - sub2)
    new(red, green, blue)
  end

  def hash
    [self.red,self.green,self.blue,self.alpha].hash
  end

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

  def to_hash
    {red: red, green: green, blue: blue, alpha: alpha}
  end

end
