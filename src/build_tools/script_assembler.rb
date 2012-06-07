=begin
  05/12/2012
  05/12/2012
=end
require_relative 'header_gen'
require_relative 'Skinj'
begin
  in_filename, filename = ARGV
  str = File.read(in_filename)
  @indent = 0
  @defines  = {"ASMxROOT"=>Dir.getwd}
  @switches = {"INCUR"=>false} 
  File.open(filename,"w+") { |f| f.write Skinj.skinj_str(str,@indent,@defines,@switches).compile }
rescue(Exception) => ex
  p ex
  puts ?-, ex.backtrace
end  
