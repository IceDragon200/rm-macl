#
# RGSS3-MACL/lib/xpan-lib/palette.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 14/06/2013
# vr 2.2.0
module MACL
  class Palette

    VERSION = "2.1.4".freeze

    class PaletteError < StandardError
    end

    include Enumerable

    ### instance_variables
    attr_accessor :palette_name
    attr_accessor :columns
    attr_accessor :cell_size
    attr_writer :can_replace_color

    ##
    # initialize(String filename)
    def initialize(filename="Graphics/System/palette.png")
      @palette_name = filename
      @sym_colors = {}
      @ext_colors = {}
      @columns = 16
      @cell_size = 8
      @can_replace_color = false
    end

    ##
    # can_replace_color?
    def can_replace_color?
      @can_replace_color
    end

    ##
    # add_sym(String name, Integer id)
    def add_sym(name, id)
      @sym_colors[name] = id.to_i
    end

    ##
    # add_ext(String name, *args)
    def add_ext(name, *args)
      case args.size
      # Color or Hex Int
      when 1
        arg, = args
        col =
          case arg
          when Numeric
            if arg > 0xFFFFFF  then Color.argb32(arg)
            elsif arg > 0xFFFF then Color.rgb24(arg)
            elsif arg > 0xFFF  then Color.argb16(arg)
            else                    Color.rgb12(arg)
            end
          #when MACL::Vector
          #  Color.new(*arg.to_a)
          when Color
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
      if !can_replace_color? && @ext_colors.has_key?(name)
        raise(PaletteError, "Color #{name} was already set!")
      else
        @ext_colors[name] = rgss_color
      end
    end

    ##
    # palette?
    def palette?
      return !(@palette.nil? || @palette.disposed?)
    end

    ##
    # reload_palette
    def reload_palette
      @palette.dispose unless @palette.nil? || @palette.disposed?
      load_palette
    end

    ##
    # load_palette
    def load_palette
      @palette = Cache.normal_bitmap(@palette_name)
    end

    ##
    # palette
    def palette
      load_palette if @palette.nil? || @palette.disposed?
      return @palette
    end

    ##
    # get_index_color(Integer index)
    def get_index_color(index)
      palette.get_pixel(
        (index % @columns) * @cell_size, (index / @columns) * @cell_size)
    end

    ##
    # sym_color(String sym)
    def sym_color(sym)
      if sym.is_a?(Symbol)
        sym = sym.to_s
        warn("use of Symbol (:#{sym}) for #{self}#sym_color is depreceated")
      end

      unless @ext_colors.has_key?(sym) || @sym_colors.has_key?(sym)
        raise(PaletteError, "no reference for color symbol #{sym} (#{sym.class})")
      end

      ex_color = @ext_colors[sym]
      return ex_color ? ex_color.dup : get_color(@sym_colors[sym])
    end

    ##
    # get_color(Integer index)
    # get_color(String name)
    def get_color(n)
      n.is_a?(Numeric) ? get_index_color(n) : sym_color(n)
    end

    ##
    # entries
    def entries
      return Hash[@sym_colors.map{|(k, v)| [k, get_color(v)] }].merge(@ext_colors)
    end

    ## Enumerable
    # each
    def each(&block)
      entries.each(&block)
    end

    ### aliases
    alias :set_color :add_ext
    alias :[] :get_color

  end
end # /MACL
