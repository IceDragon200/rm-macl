# // 04/21/2012
# // 04/21/2012
$LOAD_PATH << "C:/Lib/iExRuby/"
require 'Skrip2'
require 'Skrip2_reader'
require 'Win32API'
#require 'curses'
def unpack_skpck source
  Dir.mkdir("C:/Lib/skpck2out/") unless(File.exist?("C:/Lib/skpck2out/"))
  source  = source.dup.gsub("\\","/")
  nm      = File.basename(source)
  target  = "C:/Lib/skpck2out/#{File.basename(nm,File.extname(nm))}/"
  skpck   = load_data(source)
  raise Skrip::MissingHeader.new() unless(skpck[:header])
  Dir.mkdir(target) unless(File.exist?(target))
  ldord   = skpck[:header][:load_order]
  if(ldord)
    puts "load_order is present, outputting to #{target+"load_order.skt"}"
    File.open(target+"load_order.skt","w+") do |f|
      f.puts "// #{nm} Load Order"
      ldord.each { |s| f.puts(s) }
    end
  end
  skpck[:contents].each_pair do |key,skrip|
    puts format("Saving %s to %s%s%s",key,target,key,".rb")
    File.open(target+key+".rb","w+") { |f| f.puts(Skrip.skrip2str(skrip)) }
  end
end
begin
  puts "Unpacking..."
  ARGV.each { |fn| unpack_skpck(fn) }
rescue(Exception) => ex
  p ex.message
end
sleep 1.0