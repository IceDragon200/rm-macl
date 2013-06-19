#
# RGSS3-MACL/lib/xpan-lib/easer.rb
#   by IceDragon
#   dc 24/03/2012
#   dm 24/03/2013
# vr 2.0.0
module MACL
class Easer

  @@easers = {}

  ##
  # _ease(t, st, ch, d)
  #   note that all _ease code was created and provided by CaptainJet,
  #   unless stated otherwise
  def _ease(t, st, ch, d=1.0)
    ch + st
  end

  ##
  # ease(Float t, Numeric st, Numeric et, Float d)
  def ease(t, st, et, d=1.0, *args)
    # BUG Certain easers will return a OutOfRange Float value at 0.0 time
    #     for now, the start value will be returned for 0.0 time
    return st if t == 0
    self._ease(t, st, et - st, d, *args)
  end

  def self.register(sym, neaser=self)
    nm = self.name.gsub("MACL::Easer::", "")
    define_method(:name) { nm }
    define_method(:symbol) { sym }
    @@easers[sym] = self.new
  end

  def self.easers
    @@easers
  end

  def self.get_easer(sym)
    @@easers[sym]
  end

  def self.[](sym)
    @@easers[sym]
  end

  def self.has_easer?(sym)
    @@easers.has_key?(sym)
  end

  def self.easer
    @_easer ||= new
  end

  def self.ease(*args)
    easer.ease(*args)
  end

end
end

dir = File.dirname(__FILE__)
files = Dir.glob(File.join(dir, "easer", "*.rb"))
post_files = files.select { |fn| fn =~ /-(?:in|out|inout)/ }
(files - post_files + post_files).each do |fn|
  require fn
end
