require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../src/StandardLibEx/Hash_Ex.rb'
  hash = {
    x: 0,
    y: 18,
    z: 22
  }
  p hash
  p(hash.remap do |key,value| [key.upcase,-value] end)
  p hash
  hash.remap! do |key,value| [key.upcase,-value] end
  p hash
end