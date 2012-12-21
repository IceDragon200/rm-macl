#-// Blaz is a Sequencer class used for commands for Yggdrasil, REI and
#-// other systems
#-// By IceDragon
#-apndmacro _imported_
#-inject gen_scr_imported 'MACL::Blaz', '0x10002'
#-end:
#-inject gen_class_header 'MACL::Blaz'
module MACL
  class Blaz

    include Enumerable

    #-// block
    def initialize(&block)
      @commands = []
      instance_exec &block if block_given?
    end

    #-// Symbol[]
    def command_syms
      commands.collect &:first
    end

    #-//
    def each(&block)
      @commands.each(&block)
    end

    attr_accessor :commands

    #-//
    def to_a
      commands.to_a
    end

    #-//
    def to_hash
      sym,regex,func,params = [nil]*4
      Hash[commands.collect do |(sym,regex,func,params)| [sym,[regex,func,params]] end]
    end

    #-//
    def add_command(sym, regex, params=[], &func)
      @commands.push [sym,regex,func,params]
    end

    #-//
    def shift_command(sym, regex, params=[], &func)
      @commands.unshift [sym,regex,func,params]
    end

    #-//
    def enum_commands
      sym,regex,func,params = [nil]*4
      each do |(sym,regex,func,params)|
        yield sym,regex,func,params
      end
    end

    #-//
    def match_command str
      sym,regex,func,params = [nil]*4
      enum_commands do |sym, regex, func, params|
        regex = regex.call if regex.respond_to? :call
        mtch = str.match regex
        return if yield sym, mtch, func, params if mtch
      end
    end

    #-//
    def exec_command str
      sym,mtch,func,params = [nil] * 4
      match_command str do |sym, mtch, func, params|
        return func.call mtch
      end
    end

  end
end
