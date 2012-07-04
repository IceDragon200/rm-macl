Encoding.default_external = "UTF-8"
@default_def = {
  "C:/Lib/Git/RGSS3-MACL" => Dir.getwd,
}
@switches_def = {
  "INCUR" => false
}
def asm_folder source,target
  Dir.mkdir target unless File.exist? target
  files = Dir.entries("#{source}") - [".",".."]
  #puts "Files #{source}"
  #puts files
  files.each do |sf|
    bsn = File.basename sf
    pth = "#{source}/#{bsn}"
    trg = "#{target}/#{bsn}"
    if File.directory? pth
      puts "Entering new directory %s" % trg
      unless File.exist? trg
        puts "Making Directory: %s" % trg
        Dir.mkdir trg
      end
      asm_folder pth,trg
    else
      puts "..."
      puts "=> Making #{trg}"
      str = File.read pth
      begin
        File.open trg,"w+" do |f|
          defs,swis = @default_def.clone,@switches_def.clone
          f.write Skinj.skinj_str(str,0,defs,swis).assemble
        end
      rescue Exception => ex
        puts 'Error ocurred while Skinjing %s' % pth
        p ex
      end
    end
  end
rescue Exception => ex
  Skinj.debug_puts ex.message
end
begin
  require_relative "header_gen"
  require 'C:/Lib/Git/RGSS3-MACL/src/build_tools/Skinj'
  class Skinj
    include Skinj_Gen
  end
  argsv = ARGV.dup
  switches = argsv.select do |s| s.start_with? '--' end
  argsv -= switches
  switches.map! &:downcase
  @default_def['Game::'] = 'Game::' if switches.include? '--edos'
  @switches_def['INCUR'] = true if switches.include? '--incur'
  src,trg = argsv
  if trg.nil? or trg.empty?
    src = src[0]||Dir.getwd
    src,trg = "#{src}/src","#{src}/lib"
  end
  src = File.expand_path src
  trg = File.expand_path trg
  puts "<Source Directiory: #{src}>"
  asm_folder src,trg
  puts "Finished"
rescue Exception => ex
  p ?-, ex
end