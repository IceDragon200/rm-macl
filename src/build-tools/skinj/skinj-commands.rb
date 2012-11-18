#
# src/build-tools/skinj/skinj-commands.rb
#
class Skinj

  include Constants

  @@commands = []

  def self.add_command(sym, regexp, &block)
    nm = "asmb_" + sym.to_s
    @@commands << [sym, regexp, nm, block]
  end

  def params
    @last_params
  end

  def indent
    @last_indent
  end

end  

path = File.dirname(__FILE__)

Dir.glob(File.join(path, 'commands', '*.rb')).sort.each do |f|
  require_relative f
end
