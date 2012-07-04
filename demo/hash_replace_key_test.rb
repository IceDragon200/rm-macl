require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../src/StandardLibEx/Hash_Ex.rb'
  hash = {
    cheese: 'Hello',
    bread: 'World'
  }
  p hash
  p hash.replace_key cheese: :raisin
  p hash
  hash.replace_key! cheese: :raisin
  p hash
  p(hash.replace_key do |k| k.capitalize end)
  p hash
  hash.replace_key! do |k| k.capitalize end
  p hash
end