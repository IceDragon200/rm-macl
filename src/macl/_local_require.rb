[
  'macl.rb',
  'macl-constants',
  'macl-mixins',
  'macl-handle.rb',
  'macl-parsers.rb'
].each do |s|
  require_relative s
  puts "Loaded: #{s}"
end if $macl_load_requests.include? 'macl'