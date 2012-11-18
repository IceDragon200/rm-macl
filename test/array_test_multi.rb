require_relative '_rgss3_prototype.rb'
_demo_block do
  array = []
  array << %w(x y z)
  array << %w(0 1 2)
  array << %w(a b c)
  array << %w(cheese cookies cream)
  array.each do |(a,b,c)|
    p a,b,c
  end
end