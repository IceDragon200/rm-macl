begin
  Encoding.default_external = "UTF-8"
  source,=ARGV
  source ||= ""
  source = Dir.getwd if source.empty?
  puts "<Source Directiory: #{source}>"
  require 'C:/Lib/Git/RGSS3-MACL/src/build_tools/Skinj'
  require_relative "header_gen"
  files = Dir.glob("#{source}/src/*.{rb,txt}")
  puts "Files #{source}"
  puts files
  default_def = {
    "ASMxROOT" => Dir.getwd
  }
  files.each { |sf|
    puts "..."
    in_filename = "#{sf}"
    filename = "#{source}/lib/#{File.basename(sf)}"
    puts "=> Making #{filename}"
    str = File.read(in_filename)
    File.open(filename,"w+") { |f| f.write Skinj.skinj_str(str,default_def).compile }
  }
  puts "Finished"
rescue(Exception) => ex
  p ?-, ex
end
sleep 4.0