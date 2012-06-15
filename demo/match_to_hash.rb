require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../rgss3macl.rb'
  rgx = /hello\sworld\s(\d+)\s(\d+)\s(\d+)/i
  str = 'hello World 1 23 67'
  mtch = str.match rgx
  puts str
  puts mtch
  puts mtch.to_hash
  puts 
  rgx = /hello\sworld\s(?<n1>\d+)\s(?<n2>\d+)\s(?<n3>\d+)/i
  str = 'hello World 1 23 67'
  mtch = str.match rgx
  puts str
  puts mtch
  puts mtch.to_hash
end