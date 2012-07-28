[
  'core-metric.rb',
  'core-graphics.rb',
  'core-audio.rb',
  'core-input.rb',
  'core-table.rb',
  'core-bitmap.rb',
  'core-sprite.rb',
  'core-window.rb',
  'core-color.rb',
  'core-tone.rb',
  'core-font.rb',
  'core-rect.rb',
].each do |s|
  require_relative s
end if $macl_load_requests.include? 'core'