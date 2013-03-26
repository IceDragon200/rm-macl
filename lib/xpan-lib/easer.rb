#
# RGSS3-MACL/lib/xpan-lib/easer.rb
#   by IceDragon
#   dc 24/03/2012
#   dm 24/03/2013
# vr 2.0.0
module MACL
class Easer

  @@easers = {}

  def self.register(sym, neaser=self)
    nm = self.name.gsub("MACL::Easer::", "")
    define_method(:name) { nm }
    define_method(:symbol) { sym }
    @@easers[sym] = self.new
  end

  def self.get_easer(sym)
    @@easers[sym]
  end

  def self.easers
    @@easers
  end

  def self.has_easer?(sym)
    @@easers.has_key?(sym)
  end

  def self.easer
    @easer ||= new
  end

  def self.ease(*args)
    easer.ease(*args)
  end

  def _ease(t, st, ch, d=1.0)
    ch + st
  end

  ##
  # ease(Float t, Numeric st, Numeric et, Float d)
  def ease(t, st, et, d=1.0, *args)
    self._ease(t, st, et-st, d, *args)
  end

end
end

dir = File.dirname(__FILE__)
files = Dir.glob(File.join(dir, "easer", "*.rb"))
post_files = files.select { |fn| fn =~ /-(?:in|out|inout)/ }
(files - post_files + post_files).each do |fn|
  require fn
end
