[
  'rpg-baseitem',
  'rpg-map',
  'rpg-event-page',
].each do |s|
  require_relative s
end if $macl_load_requests.include? 'rpg'