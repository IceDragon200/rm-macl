require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../rgss3macl.rb'
  require_relative '../src/RelayIO.rb'
  relay = IO_Relay.new
  relay.add_relay $stdout
  file = File.open "LogRelay.log",?w
  file.sync = true
  relay.add_relay file

  $stdout = relay
  loop do
    begin
      puts "Input Eval"
      p eval(gets.chomp)
    rescue Exception => ex
      p ex
      retry
    end
  end
end