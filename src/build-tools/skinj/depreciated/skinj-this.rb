=begin
  05/12/2012
  05/12/2012
=end
require_relative 'header_gen'
require_relative 'skinj'

class Skinj

  include Skinj_Gen
  
end

begin
  in_filename, = ARGV
  in_filename = File.expand_path in_filename
  str = File.read in_filename
  @indent = 0
  @defines  = {"ASMxROOT"=>Dir.getwd}
  @switches = {"INCUR"=>false}
  Skinj.skinj_str(str,@indent,@defines,@switches)
rescue Exception => ex
  p ex
  puts ?-, ex.backtrace
end
