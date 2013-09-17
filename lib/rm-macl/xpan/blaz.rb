#
# rm-macl/lib/rm-macl/xpan/blaz.rb
#
require 'rm-macl/macl-core'
module MACL #:nodoc:
  class Blaz

    include Enumerable

    attr_accessor :commands

    def initialize(&block)
      @commands = []
      instance_exec &block if block_given?
    end

    #-// Symbol[]
    def command_syms
      commands.map(&:first)
    end

    #-//
    def each(&block)
      @commands.each(&block)
    end

    #-//
    def to_a
      commands.to_a
    end

    #-//
    def to_h
      sym,regex,func,params = [nil]*4
      Hash[commands.map { |(sym,regex,func,params)| [sym,[regex,func,params]] }]
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
      each do |(sym,regex,func,params)|
        yield sym,regex,func,params
      end
    end

    ##
    # match_command(String str)
    def match_command(str)
      enum_commands do |sym, regex, func, params|
        regex = regex.call if regex.respond_to? :call
        mtch = str.match regex
        return if yield sym, mtch, func, params if mtch
      end
    end

    ##
    # exec_command(String str)
    def exec_command(str)
      match_command str do |sym, mtch, func, params|
        return func.call mtch
      end
    end

  end
end
MACL.register('macl/xpan/blaz', '1.1.0')