#
# src/xpan-lib/pallete.rb
#
# vr 1.10
module Pallete

  @sym_colors = {}
  @ext_colors = {}

  def self.pallete?
    return !(@pallete.nil? || @pallete.disposed?)
  end

  def self.reload_pallete
    @pallete.dispose unless @pallete.nil? || @pallete.disposed?
    load_pallete
  end

  def self.load_pallete
    @pallete = Cache.system("pallete.png")
  end

  def self.pallete
    load_pallete unless @pallete || @pallete
    return @pallete
  end

  def self.get_color(index)
    pallete.get_pixel (index % 16) * 8, (index / 16) * 8
  end

  def self.sym_color(symbol)
    @ext_colors[symbol] || get_color(@sym_colors[symbol] || 0)
  end

  def self.[](n)
    n = n.to_s if n.is_a?(Symbol)
    n.is_a?(String) ? sym_color(n) : get_color(n)
  end

end
