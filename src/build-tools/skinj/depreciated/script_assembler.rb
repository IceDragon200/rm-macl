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
  in_filename, filename = ARGV
  in_filename = File.expand_path in_filename
  filename = File.expand_path filename
  str = File.read in_filename
  @indent = 0
  @defines  = {"ASMxROOT"=>Dir.getwd}
  @switches = {"INCUR"=>false}
  File.open filename,"w+" do |f|
    f.write Skinj.skinj_str(str,@indent,@defines,@switches).assemble
  end
rescue Exception => ex
  p ex
  puts ?-, ex.backtrace
end
