# // 06/15/2012
# // 06/15/2012
require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../rgss3macl.rb'
  commands = Blaz.new
  commands.add_command :help, /\A!help/i do
    puts "-Help-"
    puts "!help"
    puts "!time"
    puts "!poke <nick>"
    puts "!quit"
  end
  commands.add_command :time, /\A!time/i do
    puts Time.now.to_s
  end
  commands.add_command :poke, /\A!poke\s(?<nick>\S+)/i do |match|
    puts "* Ruby pokes %s" % match[:nick]
  end
  commands.add_command :quit, /\A!quit/i do |match|
    break
  end
  loop do
    print '<you> '
    str = gets.chomp
    commands.exec_command str
  end
end