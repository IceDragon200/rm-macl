require_relative 'common.rb'
log = STDERR
r = MACL::Geometry::Polygon.new(5, 0, 0, 42, 42)
log.puts "Polygon Points: #{r.points}"
log.puts "Polygon#lerp"
points = []
keyframes = 128
(keyframes + 1).times do |i|
  delta = i.to_f / keyframes.to_f
  points << r.path_lerp(delta)
end
plot_graph(points)