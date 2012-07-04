class Array
  def reverse_index obj=nil
    if block_given?
      size.downto(0) do |i| return i if yield(self[i]) end
    else
      i = 0
      size.downto(0) do |i| return i if self[i] == obj end
    end
    -1
  end
  def reverse_index_old obj=nil
    if block_given? ; size.downto(0) do |i| return i if yield(self[i]) end
    else            ; size.downto(0) do |i| return i if self[i] == obj end
    end
    -1
  end
end
require 'benchmark'
begin
  array = Array.new 256**2,0
  array[0] = 1
  results = 20.times.collect do
    result1 = Benchmark.measure do
      array.reverse_index 1
    end
    result2 = Benchmark.measure do
      array.reverse_index_old 1
    end
    [result1,result2]
  end
  hash = results.inject({new_i: [], old_i: []}) do |r,i| 
    r[:new_i] << i[0]
    r[:old_i] << i[1]
    r
  end
  puts "reverse_index"
  puts hash[:new_i]
  puts "reverse_index_old"
  puts hash[:old_i]
  gets
  results = 20.times.collect do
    result1 = Benchmark.measure do
      array.reverse_index do |i| i == 1 end
    end
    result2 = Benchmark.measure do
      array.reverse_index_old do |i| i == 1 end
    end
    [result1,result2]
  end
  hash = results.inject({new_i: [], old_i: []}) do |r,i| 
    r[:new_i] << i[0]
    r[:old_i] << i[1]
    r
  end
  puts "reverse_index"
  puts hash[:new_i]
  puts "reverse_index_old"
  puts hash[:old_i]
  gets
end
