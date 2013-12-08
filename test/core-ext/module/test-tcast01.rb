require_relative 'common.rb'
class MyRect < Rect
end
r = Rect.new(0, 0, 32, 32)
ra = [2, 3, 32, 32]
p Rect.tcast(r)
p Rect.tcast(ra)
p MyRect.tcast(r)
p MyRect.tcast(ra)