require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../src/xpanlib/fifo'
  require_relative '../src/standardlibex/Numeric_Ex'
  require_relative '../src/standardlibex/Array_Ex'
  
  def fifo_test fifo
    puts "[1]"
    puts fifo[1]
    puts "[1..5]"
    puts fifo[1..5]
    puts "[1,5,9]"
    puts fifo[1,5,9]
    puts "sample"
    puts fifo.sample

    puts "each"
    fifo.each do |i| puts i end
    puts "+ temp"
    puts fifo + [11,12,13,14,15]
    puts fifo
    puts "+ perm"
    puts fifo += [11,12,13,14,15]
    puts fifo
    puts "- temp"
    puts fifo - [6,7,8,9,10]
    puts fifo
    puts "- perm"
    puts fifo -= [6,7,8,9,10]
    puts fifo
    puts "* temp int"
    puts (fifo * 3).inspect
    puts "* temp str"
    puts (fifo * ?,).inspect
    #puts "* perm"
    puts "resize 15 elem"
    puts fifo.resize 15, -1
    puts fifo
    puts "resize 15 block"
    puts fifo.resize 15 do 10+rand(20) end
    puts fifo
    puts "resize! 15 elem"
    puts fifo.resize! 15, -1
    puts fifo
    puts "resize! 15 block"
    puts fifo.resize! 15 do 10+rand(20) end
    puts fifo

    puts "reject < 10"
    puts(fifo.reject do |i| i.to_i < 10 end)
    puts fifo
    puts "reject! < 10"
    puts(fifo.reject! do |i| i.to_i < 10 end)
    puts fifo
  end   
  #tmp = Fifo.new 10 do |i| i+1 end
  #fifo_test tmp
  puts "with default"
  tmp = MACL::Fifo.new 10 do |i| i+1 end
  tmp.default = 0
  fifo_test tmp
end