($imported||={})['Task']=0x10000
class Task
  FUNC_TASK_SELECT = proc do |t| t.update;!t.done? end 
  @@single = []
  @@loop = []
  class << self
    alias :nnew :new
    def new *args,&block
      obj = nnew *args,&block
      obj.remote = true
      obj
    end
    def add_task time,&func
      @@single << nnew(time,&func)
    end
    def add_task_loop time,&func
      @@loop << Looped.nnew(time,&func)
    end
    def clear
      (@@single+@@loop).each do |t| t.terminate end
      @@single.clear;@@loop.clear
    end
    def update
      return if @paused
      update_tasks
    end
    def update_tasks
      @@single.select! &FUNC_TASK_SELECT
      @@loop.select! &FUNC_TASK_SELECT
    end
    def pause
      @paused = true
    end
    def unpause
      @paused = false
    end
    alias resume unpause
  end
  class Looped < self
    def update
      return unless super
      reset if @called
    end
  end
  attr_accessor :time, :function, :called  
  def initialize time, &function
    @time_cap = @time = time
    @function = function
    @terminated, @called = [false]*2
    @remote = false
  end
  def terminate
    @terminated = true
  end
  def update
    return false if @terminated
    @time = @time.pred.max 0
    (@function.call; @called = true) if @time == 0 unless @called
    true
  end
  def reset
    @time = @time_cap
    @called = false
  end
  attr_accessor :remote
  def remote?
    @remote
  end
  def done?
    @time == 0 and @called
  end
end