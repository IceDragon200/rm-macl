#-//06/02/2012
#-//06/02/2012
#-apndmacro _imported_
#-inject gen_scr_imported 'Core-Font', '0x10001'
#-end:
#-inject gen_class_header 'Font'
class Font

  def to_hsh
    {
      :color       => font.color.to_color,
      #:shadow_color => font.shadow_color.to_color, YGG1x*
      :out_color    => font.out_color.to_color,
      :name         => self.name.to_a.clone,
      :size         => self.size.to_i,
      :bold         => self.bold.to_bool,
      :italic       => self.italic.to_bool,
      :shadow       => self.shadow.to_bool,
      :outline      => self.outline.to_bool
    }
  end

  def marshal_dump
    to_hsh
  end

  def marshal_load hsh
    hsh.each_pair do |key,value|
      send(key.to_s+?=,value)
    end
  end

end
