begin
  require_relative '_rgss3_prototype.rb'
  require_relative '../rgss3macl.rb'
  ["ON", "OFF", "TRUE", "false", "T", "F"].each do |s|
    puts "%s = %s" % [s,MACL::Parsers.str2bool(s)]
  end
  gets
rescue Exception => ex
  p ex
  gets  
end