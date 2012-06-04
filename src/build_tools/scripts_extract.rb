# // 05/01/2012
# // 05/01/2012
# // Created by IceDragon 
Encoding.default_external = "UTF-8"
begin
  $LOAD_PATH << "C:/Lib/Git/RGSS3-MACL/src"
  require 'iExRuby'
  require 'Zlib' 
  # // Order to my madness
  filename = ARGV[0]||"#{Dir.getwd.gsub("\\",'/')}/Scripts.rvdata"
  folder_name = ARGV[1]||File.basename(filename,File.extname(filename))
  puts 'extracting'
  fn = filename
  arra = load_data(fn)
  puts "Opened %s" % fn
  Dir.mkdir(folder_name) unless(File.exist?(folder_name))
  # // 3 Element Array collection containing, checksum, name, zlib-ed string (script)
  arra.each_with_index do |a,i|
    checksum, name, zstr = a
    name = name
    fn = ("%s/[%d]%s.%s"%[folder_name,i,name.strip.chomp.gsub(/[\>\<\:\;\\\/\|\*\?\"\'\!\,\^\%\$\#\@\~\`]/,""),"rb"])
    puts "Found #{name}"
    puts "Writing #{fn}"
    File.open(fn,"w+") do |f|
      f.puts("# "+name)
      f.puts(Zlib.inflate(zstr))
    end
  end
  puts "Extraction complete!"
  sleep 4.0
rescue(Exception) => ex
  puts "ERROR"
  puts ex.message
  sleep 4.0
end