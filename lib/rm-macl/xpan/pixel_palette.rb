#
# rm-macl/lib/rm-macl/xpan/pixel_palette.rb
#   by IceDragon
require 'rm-macl/macl-core'
module MACL #:nodoc:
  class PixelPalette

    ### mixins
    include Enumerable

    ### instance_variables
    attr_accessor :palette_name
    attr_accessor :columns
    attr_accessor :cell_size

    def initialize(filename="Graphics/System/palette.png")
      @palette_name = filename
      @columns = 16
      @cell_size = 8
      @color_index = {}
      reload_palette
    end

    ##
    # disposed? -> bool
    def disposed?
      !!@disposed
    end

    ##
    # dispose_palette
    def dispose_palette
      @palette.dispose if @palette && !@palette.disposed?
    end

    ##
    # dispose -> bool
    def dispose
      dispose_palette
      @disposed = true
    end

    ##
    # refresh_keys
    def refresh_keys
      @color_index.replace(Hash[@color_index.map{ |(k, v)| [cast_key(k), v] }])
    end

    ##
    # set_index(String name, Integer id)
    def set_color(osym, id)
      sym = cast_key(osym)
      @color_index[sym] = id.to_i
    end

    ##
    # palette?
    def palette?
      return !(@palette.nil? || @palette.disposed?)
    end

    ##
    # reload_palette
    def reload_palette
      dispose_palette
      load_palette
    end

    ##
    # load_palette
    def load_palette
      @palette = Bitmap.new(@palette_name)
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

    def get_color(index)
      case index
      when Numeric
        get_index_color(index)
      else
        (n = @color_index[index]) ? get_index_color(n) : nil
      end
    end

    def entries
      Hash[@color_index.map{|(k, v)| [k, get_color(v)] }]
    end

    ## Enumerable
    # each
    def each(&block)
      entries.each(&block)
    end

    ### aliases
    alias :[]= :set_color
    alias :[] :get_color

  end
end
MACL.register('macl/xpan/pixel_palette', '1.1.0')