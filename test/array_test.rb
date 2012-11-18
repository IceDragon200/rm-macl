require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../rgss3macl.rb'
  array = [1,2,3,0,0]
  puts 'Selecting all Zeros in %s' % array.inspect
  puts array.select(&:zero?)
end