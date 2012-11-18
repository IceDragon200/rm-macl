require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../rgss3macl.rb'
  ["ON", "OFF", "TRUE", "false", "T", "F"].each do |s|
    puts "%s = %s" % [s,MACL::Parsers.str2bool(s)]
  end
end