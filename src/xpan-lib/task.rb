#-// Task by CaptainJet
#-// Rewritten by IceDragon (06/15/2012)
#
# src/xpan-lib/task.rb
#
# vr 1.1
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
