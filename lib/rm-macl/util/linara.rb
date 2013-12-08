#
# rm-macl/lib/rm-macl/util/linara.rb
#   by IceDragon
# Orginally apart of the rm-rice library, Linara has made its way into the
# rm-macl.
#
# Linara is a priority based loading Module.
# The rm-macl adoptation has removed the unloading functions,
# however it has been changed it to a Class.
require 'rm-macl/macl-core'
require 'rm-macl/mixin/log'
module MACL #:nodoc:
  class Linara

    include MACL::Mixin::Log

    attr_accessor :debug # Boolean
    attr_reader :last_exception

    def initialize
      @list           = []
      @loaded         = []
      @debug          = false # Debug mode
      @last_exception = nil
    end

    ##
    # Should loading continue regardless of error state?
    def continue_on_failure?
      return @debug
    end

    ##
    #
    def add(id, priority=0, enabled=true, &func)
      @list.push({ priority: priority, id: id,
                   func: func, source: caller.drop(1), enabled: enabled })
      self
    end

    def run
      try_log { |log| log.puts("Linara | NOW RUNNING") }
      # clear the @loaded list
      @loaded.clear
      alist = @list.dup
      ### MicroLoading
      #alist = [] # if using micro loading
      ## setup a Hash using the load list ids as keys
      #table = Hash[@list.map { |hsh| [hsh[:id], hsh] }]
      ## setup a weight table (this will be used for micro sorting)
      #weights = {}
      #@list.each do |hsh|
      #  # in the rm-rice Linara, only Numeric was used for priority
      #  case pri = hsh[:priority]
      #  when Numeric
      #    new_hsh = hsh.dup
      #    new_hsh[:priority] = [new_hsh[:priority], 0]
      #  # with the rm-macl version of Linara, priorities can be Arrays
      #  # containing an operator and id
      #  # This will cause the loader to be calculated based on an existing
      #  when Array
      #    op, id = pri
      #    if tab_hsh = table.fetch(id)
      #      weights[:id] ||= [0, 0]
      #      case op
      #      when :== # with
      #        weight = 0
      #      when :>> # after
      #        weight = weights[:id][0] += 1
      #      when :<< # before
      #        weight = -(weights[:id][1] += 1)
      #      end
      #      new_hsh = hsh.dup
      #      new_hsh[:priority] = [tab_hsh[:priority], weight]
      #    end
      #  else
      #    raise TypeError, "expected type Array or Numeric but recieved #{pri.class}"
      #  end
      #  alist << new_hsh
      #end

      alist.sort_by! { |hsh| hsh[:priority] }

      alist.each do |hsh|
        next unless hsh[:enabled]
        priority, id, func = hsh[:priority], hsh[:id], hsh[:func]
        begin
          func.call
          try_log do |log|
            str = "[SUCCESS] [%03s %0-40s]"
            load_str = str % [priority, id]
            log.puts(load_str)
          end
          @loaded.push(hsh[:id])
        rescue Exception => ex
          @last_exception = ex
          if continue_on_failure?
            try_log do |log|
              str = "[FAILURE] [%03s %0-40s]"
              excep_str = ex.inspect
              backtrc   = ex.backtrace.join("\n")
              load_str  = str % [priority, id]
              log.puts(load_str)
              log.puts(excep_str)
              log.puts(backtrc)
            end
          else
            raise ex
          end
        end
      end
      self
    end

    private :try_log

  end
end
MACL.register('macl/util/linara', '1.2.0')