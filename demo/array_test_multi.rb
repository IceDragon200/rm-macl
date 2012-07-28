require_relative '_rgss3_prototype.rb'
_demo_block do
  array = []
  array << [?x,?y,?z]
  array << [0,1,2]
  array << [?a,?b,?c]
  array << ['cheese','cookies','cream']
  array.each do |(a,b,c)|
    p a,b,c
  end
end