#-//06/02/2012
#-//06/02/2012
#-apndmacro _imported_
#-inject gen_scr_imported 'Core-Rect', '0x10001'
#-end:
#-inject gen_class_header 'Rect'
class Rect

  def empty?
    self.width == 0 or self.height == 0
  end unless method_defined?(:empty?)

end
