[
  'Object_Ex.rb',
  'Module_Ex.rb',
  'Kernel_Ex.rb',
  'Numeric_Ex.rb',
  'String_Ex.rb',
  'Array_Ex.rb',
  'Hash_Ex.rb',
  'MatchData_Ex.rb',
].each do |s|
  require_relative s
end if $macl_load_requests.include? 'std'