require 'benchmark'
require_relative '_rgss3_prototype.rb'
class Hash
  def rename_key! name, res
    self[res] = self.delete name
    self
  end
end
_demo_block do
  require_relative '../src/StandardLibEx/Hash_Ex.rb'
  hash = {}
  sleep 2.0
  results = 10.times.collect do
    6000.times do |i| hash["test_%s" % i] = rand(100) end
    nhash = hash.dup
    result1 = Benchmark.measure do
      hash.replace_key! do |k| k.upcase.to_sym end
    end
    result2 = Benchmark.measure do
      nhash.keys.to_a.each do |i| nhash.rename_key! i, i.upcase.to_sym end
    end
    [result1, result2]
  end
  hsh = [[],[]]
  results.each do |(res1,res2)| hsh[0] << res1; hsh[1] << res2 end
  puts 'replace_key!'
  puts hsh[0].join("")
  puts
  puts 'rename_key!'
  puts hsh[1].join("")
end