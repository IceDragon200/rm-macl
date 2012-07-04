#-// 12/??/2011
#-// 06/06/2012
#-// Version : 1.0
#-inject gen_module_header 'Pallete'
#-inject gen_scr_imported_ww 'Pallete', '0x10000'
module Pallete
  @sym_colors = {}
  #--------------------------------------------------------------------------#
  # ● module-method :pallete
  #/------------------------------------------------------------------------\#
  # ● Return
  #     Bitmap
  #\------------------------------------------------------------------------/#
  def self.pallete
    @pallete = Cache.system "Pallete" if @pallete.nil? || @pallete.disposed?
    return @pallete
  end
  #--------------------------------------------------------------------------#
  # ● module-method :get_color
  #/------------------------------------------------------------------------\#
  # ● Parameter
  #     index (Integer)
  # ● Return
  #     Color
  #\------------------------------------------------------------------------/#
  def self.get_color index
    pallete.get_pixel (index % 16) * 8, (index / 16) * 8
  end
  #--------------------------------------------------------------------------#
  # ● module-method :sym_color
  #/------------------------------------------------------------------------\#
  # ● Parameter
  #     symbol (Symbol)
  # ● Return
  #     Color
  #\------------------------------------------------------------------------/#
  def self.sym_color symbol
    get_color( @sym_colors[symbol] || 0 )
  end
  #--------------------------------------------------------------------------#
  # ● module-method :[]
  #/------------------------------------------------------------------------\#
  # ● Refer to
  #     get_color
  #\------------------------------------------------------------------------/#
  def self.[] n
    n.is_a?(Symbol) ? sym_color(n) : get_color(n)
  end
end