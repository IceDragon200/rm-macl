#==============================================================================#
# ? Console_Command 
#==============================================================================#
# // • Created By    : IceDragon
# // • Data Created  : 01/14/2012
# // • Data Modified : 01/14/2012
# // • Version       : 1.0
#==============================================================================#
require 'MixIn_ConsoleHelpers'
class Console_Command
  include MixIn_ConsoleHelpers
  attr_reader :list
  attr_reader :handler
  def initialize( maintext="console " )
    @maintext = maintext
    @list    = []
    @handler = {}
  end
  def clear_commands()
    @list.clear()
  end
  def add_command( symbol, command, method )
    @list << symbol 
    @handler[symbol] = Command.new(command, method)
  end
  def run
    catch(:end_run) do 
      loop do
        print "<#{@maintext}@> "
        com = gets.chomp
        nc = true
        @list.each do |a|
          hnd = @handler[a]
          next unless hnd.can_match?
          m = hnd.match(com) 
          if m
            a = m.to_a ; a.shift
            nc = false
            throw :end_run if hnd.call(*a) 
            break
          end  
        end
        @handler[:nocommand].call(com.to_s) if @handler[:nocommand] if nc
      end
    end  
  end
  class Command
    def initialize( regex, method )
      @regex = regex
      @method = method
    end
    def can_match?()
      !@regex.nil? 
    end
    def match(*args)
      @regex.match(*args)
    end
    def call(*args)
      @method.call(*args) if @method
    end  
  end
end
#=¦==========================================================================¦=#
#                           // ? End of File ? //                              #
#=¦==========================================================================¦=#