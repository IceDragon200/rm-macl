=begin
  
  RGSS3 Prototype
  Based on Enterbrain's Rpg Maker VX Ace, RGSS3 Library

  Written By IceDragon
  
=end
begin
  require 'win32api'
rescue LoadError
  class Win32API
    def initialize *args, &block
      @stuff = [args, block]
    end
    def call *args, &block
      warn 'win32api was not loaded, ignoring function'
      false
    end
  end  
end  
require 'zlib'
require 'dl'
require 'gosu'
require 'texplay'

$rgx3_gosu = Object.const_defined? :Gosu

src = File.join(File.dirname(__FILE__), 'src/*.rb')
ext = File.join(File.dirname(__FILE__), 'ext/*.rb')

module Disposable

  def disposed?
    !!@disposed
  end

  def dispose
    @disposed = true
  end

end

# // Grab the shiz
(Dir[src]+Dir[ext]).each do |s|
  require s
end
