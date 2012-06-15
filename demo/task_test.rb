require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../rgss3macl.rb'
  require_relative '../src/XpanLib/Task.rb'
  remote = Task.new 10 do puts 'Hello from remote task' end
  Task.add_task 10 do puts 'Hello from inner task' end
  Task.add_task_loop 20 do puts 'Hello from loop task' end
  loop do
    Graphics.update
    remote.update unless remote.done?
    Task.update
  end
end