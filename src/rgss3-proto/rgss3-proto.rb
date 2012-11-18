=begin
  
  RGSS3 Prototype
  Based on Enterbrain's Rpg Maker VX Ace, RGSS3 Library

  Written By IceDragon
  
=end
begin
  require 'win32api'
rescue LoadError

  class Win32API

    def initialize(*args, &block)
      @stuff = [args, block]
    end

    def call(*args, &block)
      warn 'Win32API was not loaded, ignoring function'
      false
    end
  end  
  
end  

require 'zlib'
require 'dl'
require 'gosu'
require 'texplay'

$rgx3_gosu = Object.const_defined? :Gosu

module Disposable

  def disposed?
    !!@disposed
  end

  def dispose
    @disposed = true
  end

end

src = File.join(File.dirname(__FILE__), 'src/*.rb')
ext = File.join(File.dirname(__FILE__), 'ext/*.rb')
vxac= File.join(File.dirname(__FILE__), 'vxa-closed/*.rb')
vxao= File.join(File.dirname(__FILE__), 'vxa-open/*.rb')

# // Grab the shiz
(Dir[src] + Dir[ext] + Dir[vxac] + Dir[vxao]).each do |s|
  require s
end
