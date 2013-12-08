require_relative 'common.rb'
log = STDERR
r = MACL::Geometry::Rectangle.new(32, 32, 96, 96)
log.puts "Rectangle Points: #{r.points}"
log.puts "Rectangle#lerp"
rd = Rdata.new
points = []
keyframes = 24
(keyframes + 1).times do |i|
  delta = i.to_f / keyframes.to_f
  points << r.path_lerp(delta)
end
plot_graph(points)