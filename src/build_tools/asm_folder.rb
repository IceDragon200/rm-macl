Encoding.default_external = "UTF-8"
@default_def = {
  "ASMxROOT" => Dir.getwd
}
@switches_def = {
  "INCUR" => false
}
def asm_folder(source,target)
  files = Dir.entries("#{source}") - [".",".."]
  #puts "Files #{source}"
  #puts files
  files.each do |sf|
    bsn = File.basename(sf)
    pth = "#{source}/#{bsn}"
    trg = "#{target}/#{bsn}"
    if File.directory?(pth)
      puts "Entering new directory %s" % trg
      unless File.exist?(trg) 
        puts "Making Directory: %s" % trg
        Dir.mkdir(trg) 
      end  
      asm_folder(pth,trg)
    else
      puts "..."
      puts "=> Making #{trg}"
      str = File.read(pth)
      File.open(trg,"w+") { |f| f.write Skinj.skinj_str(str,0,@default_def.dup,@switches_def.dup).compile }
    end  
  end
rescue Exception => ex
  Skinj.debug_puts ex.message
end
begin
  require 'C:/Lib/Git/RGSS3-MACL/src/build_tools/Skinj'
  require_relative "header_gen"
  src  = ARGV[0]||(Dir.getwd)
  puts "<Source Directiory: #{src}>"
  asm_folder("#{src}/src","#{src}/lib")
  puts "Finished"
rescue(Exception) => ex
  p ?-, ex
end