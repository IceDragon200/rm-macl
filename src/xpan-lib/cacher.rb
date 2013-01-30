#
# src/xpan-lib/cacher.rb
#
module MACL
class Cacher

  class CacheError < StandardError
  end

  def initialize
    @constructor = {}
    clear
  end

  ##
  # construct(char* name)
  #
  # &block should return a Bitmap
  def construct(name, &block)
    warn("Constructor \"#{name}\" already exists!") if @constructor[name]
    @constructor[name] = block
  end

  ##
  # bitmap(char* name)
  #
  def bitmap(name)
    bmp = @cache[name]
    @cache[name] = nil if bmp and bmp.disposed?
    constructor = @constructor[name]
    raise(CacheError,
          "Constructor \"#{name}\" does not exist!") unless constructor
    return @cache[name] ||= constructor.call
  end

  alias :[] :bitmap

  def clear
    @cache ||= {}
    @cache.each_value do |bmp| bmp.dispose if bmp and !bmp.disposed? ; end
    @cache.clear
    GC.start
  end

end
end
