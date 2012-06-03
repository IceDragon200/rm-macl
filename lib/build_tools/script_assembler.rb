=begin
  05/12/2012
  05/12/2012
=end
require_relative 'header_gen'
require_relative 'Skinj'
begin
  in_filename, filename = ARGV
  str = File.read(in_filename)
  @defines  = {"ASMxROOT"=>Dir.getwd}
  @switches = {"INCUR"=>false} 
  File.open(filename,"w+") { |f| f.write Skinj.skinj_str(str,@defines,@switches).compile }
  sleep 2.0
rescue(Exception) => ex
  p ex
  puts ?-, ex.backtrace
  sleep 4.0
end  