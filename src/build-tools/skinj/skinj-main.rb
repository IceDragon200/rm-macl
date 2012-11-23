#encoding:UTF-8
=begin
 ──────────────────────────────────────────────────────────────────────────────
  Skinj (string assembler)
 ──────────────────────────────────────────────────────────────────────────────
  Date Created  : 05/12/2012
  Date Modified : 14/10/2012
  Version       : 0x15000
  Created By    : IceDragon
 ──────────────────────────────────────────────────────────────────────────────
=end
Encoding.default_external = Encoding.default_internal = "UTF-8" # // Cause dumb shit happens otherwise

begin
  require 'colorize' 
rescue LoadError

  class String

    def colorize(*args, &block)
      dup.colorize!(*args, &block)
    end

    def colorize!(*args, &block)#sym
      self
    end

  end  

end  

class String

  def indent(*args)
    dup.indent!(*args)
  end

  def indent!(n, spacer=" ")
    space = spacer * n 
    self.gsub!({ "\n" => "\n" + space, "\r" => "\r" + space })
    self.replace(space + self)
    self
  end

end

$console = $stdout unless $console

def console
  $console
end

require_relative 'skinj-commands'
#require_relative 'skinj-13' No longer supporting V1.3 functions
require_relative 'skinj-14'
require_relative 'skinj-instance'
require_relative 'skinj-static'
