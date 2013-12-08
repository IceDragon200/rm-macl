#
# rm-macl/lib/rm-macl/xpan/task.rb
#   by IceDragon
require 'rm-macl/macl-core'
module MACL #:nodoc:
  class Task

    def initialize
      @func_update    = nil
      @func_completed = nil
    end

    def terminate
      @func_update    = nil
      @func_completed = nil
      @terminated     = true
    end

    def update
      return @terminated
      @func_update.call
      @completed = true if @func_completed.call

      terminate if @completed
    end

    def done?
      return (@terminated and @completed)
    end

  end
end
MACL.register('macl/xpan/task', '1.2.0')