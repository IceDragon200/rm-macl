#
# rm-macl/lib/rm-macl/xpan/palette.rb
#   by IceDragon
require 'rm-macl/macl-core'
module MACL #:nodoc:
  class Palette

    ### errors
    class PaletteError < RuntimeError
    end

    ### mixins
    include Enumerable

    ### instance_variables
    attr_writer :can_replace_color
    attr_accessor :name

    ##
    # initialize
    def initialize
      @colors = {}
      @can_replace_color = true
      @name = ''
      yield self if block_given?
    end

    ##
    # cast_key(Object sym)
    def cast_key(sym)
      return sym # overwrite in subclass
    end

    ##
    # entries
    def entries
      return @colors.entries
    end

    ## Enumerable
    # each
    def each(&block)
      entries.each(&block)
    end

    ##
    # refresh_keys
    def refresh_keys
      @colors.replace(Hash[@colors.map{ |(k, v)| [cast_key(k), v] }])
    end

    ##
    # can_replace_color?
    def can_replace_color?
      @can_replace_color
    end

    ##
    # has_color?(Symbol sym) -> Color or false
    # has_color?(String sym) -> Color or false
    def has_color?(sym)
      return @colors[sym] || false
    end

    ##
    # set_color_abs(String|Symbol osym, Color color)
    def set_color_abs(sym, color)
      @colors[sym] = color
    end

    ##
    # set_color(String|Symbol osym, *args)
    def set_color(osym, *args)
      sym = cast_key(osym)
      case args.size
      # Color or Hex Int
      when 1
        arg, = args
        col = Convert.Color(arg)
        rgss_color = col
      when 3, 4
        r, g, b, a = *args
        a ||= 0xFF
        rgss_color = Color.new(r, g, b, a)
      else
        raise(ArgumentError, "expected 1, 3, or 4 but recieved %d" % args.size)
      end
      if !can_replace_color? && has_color?(sym)
        raise(PaletteError, "Color #{sym} was already set!")
      else
        set_color_abs(sym, rgss_color)
      end
    end

    ##
    # get_color(String|Symbol sym) -> Color
    def get_color(osym)
      sym = cast_key(osym)
      if color = has_color?(sym)
        return color.dup
      else
        sug = entries.find { |(k, v)| k.to_s.casecmp(sym.to_s) == 0 }
        msg = "#{self} has no reference for color symbol #{sym} (#{sym.class})."
        if sug
          msg.concat(" did you mean #{sug[0]} (#{sug[0].class})?")
        else
          msg.concat("\n where you looking for one of these: \n#{keys.inspect}")
        end
        raise(PaletteError, msg)
      end
    end

    def freeze_entries
      @colors.each_value(&:freeze)
    end

    def import(other_palette)
      other_palette.entries.each do |(k, v)|
        set_color(k, v.dup)
      end
      return self
    end

    ##
    # keys -> String / Symbol
    def keys
      @colors.keys
    end

    ### Hash interface
    def key?(key)
      sym = cast_key(key)
      @colors.key?(sym)
    end

    ### aliases
    alias :[]= :set_color
    alias :[] :get_color

  end
end # /MACL
MACL.register('macl/xpan/palette', '2.3.2') if defined?(MACL.register)