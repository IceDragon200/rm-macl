[
  'archijust.rb',
  'table-ex.rb',
  'fifo.rb',
  'point.rb',
  'cube.rb',
  'drool.rb',
  'arraytable.rb',
  'surface.rb',
  'pallete.rb',
  'morph.rb',
  'interpolate.rb',
  'grid.rb',
  'sequencer.rb',
  'tween.rb',
  'task.rb',
  'chitat.rb',
  'blaz.rb',
  'geometry.rb'
].each do |s|
  require_relative s
end if $macl_load_requests.include? 'xpan'