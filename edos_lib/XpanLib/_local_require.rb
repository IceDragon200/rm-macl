[
  'Archijust.rb',
  'TableExpansion.rb',
  'Fifo.rb',
  'Point.rb',
  'Cube.rb',
  'Drool.rb',
  'ArrayTable.rb',
  'Surface.rb',
  'Pallete.rb',
  'Morph.rb',
  'Interpolate.rb',
  'Grid.rb',
  'Sequencer.rb',
  'Tween.rb',
  'Task.rb',
  'Chitat.rb',
  'Blaz.rb',
  'Geometry.rb'
].each do |s|
  require_relative s
end if $macl_load_requests.include? 'xpan'