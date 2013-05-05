#
# RGSS3-MACL/lib/xpan-lib/pallete.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 2.1.3
module MACL
class Pallete

  class PalleteError < StandardError
  end

  attr_accessor :pallete_name, :columns, :cell_size

  def initialize(filename="Graphics/System/pallete.png")
    @pallete_name = filename
    @sym_colors = {}
    @ext_colors = {}
    @columns = 16
    @cell_size = 8
  end

  def add_sym(name, id)
    @sym_colors[name] = id.to_i
  end

  def add_ext(name, *args)
    case args.size
    # Color or Hex Int
    when 1
      arg, = args
      col =
        if arg.is_a?(Numeric)
          if arg > 0xFFFFFF  then Color.argb32(arg)
          elsif arg > 0xFFFF then Color.rgb24(arg)
          elsif arg > 0xFFF  then Color.argb16(arg)
          else                    Color.rgb12(arg)
          end
        elsif arg.is_a?(Color)
          arg.dup
        else
          raise(TypeError, "cannot convert %s into %s" % [arg, Color])
        end
      rgss_color = col
    when 3, 4
      r, g, b, a = *args
      a ||= 0xFF
      rgss_color = Color.new(r, g, b, a)
    else
      raise(ArgumentError, "expected 1, 3, or 4 but recieved %d" % args.size)
    end
    if @ext_colors.has_key?(name)
      raise(PalleteError, "Color #{name} was already set!")
    else
      @ext_colors[name] = rgss_color
    end
  end

  def pallete?
    return !(@pallete.nil? || @pallete.disposed?)
  end

  def reload_pallete
    @pallete.dispose unless @pallete.nil? || @pallete.disposed?
    load_pallete
  end

  def load_pallete
    @pallete = Cache.normal_bitmap(@pallete_name)
  end

  def pallete
    load_pallete if @pallete.nil? || @pallete.disposed?
    return @pallete
  end

  def get_color(index)
    pallete.get_pixel(
      (index % @columns) * @cell_size, (index / @columns) * @cell_size)
  end

  def sym_color(sym)
    if sym.is_a?(Symbol)
      sym = sym.to_s
      warn("use of Symbol (:#{sym}) for #{self}#sym_color is depreceated")
    end

    unless @ext_colors.has_key?(sym) || @sym_colors.has_key?(sym)
      raise(PalleteError, "no reference for color symbol #{sym} (#{sym.class})")
    end

    ex_color = @ext_colors[sym]
    return ex_color ? ex_color.dup : get_color(@sym_colors[sym])
  end

  def [](n)
    n.is_a?(Numeric) ? get_color(n) : sym_color(n)
  end

  def entries
    return Hash[@sym_colors.map{|(k, v)| [k, get_color(v)] }].merge(@ext_colors)
  end

  alias :set_color :add_ext

end
end # /MACL
