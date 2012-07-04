# // 04/17/2012
# // 04/17/2012
$LOAD_PATH << "C:/Lib/iExRuby/"
require 'Skrip2'
require 'Win32API'
HELP = %Q(
  USAGE: mkskpck.rb folder_name target_folder
)
GPS  = Win32API.new( "kernel32", "GetPrivateProfileStringA", "pppplp", "l")
begin
  params = ARGV
  puts params
  src = trg = nil
  if(params.size != 2)
    if(params.size==1)
      if(File.exist?("mkskpck.ini"))
        puts "Using mkskpck.ini DEFAULT_OUT_PATH"
        str = "\0" * 256
        GPS.call( 'SKPCK',' DEFAULT_OUT_PATH', '', str, 255, ".\\mkskpck.ini" )
        str.delete!("\0")
        src, trg = params[0], str
      end
    end
  else
    src, trg = params
  end
  if(src && trg)
    Skrip.folder2skpck(src,trg)
  else
    puts HELP
  end
rescue(Exception) => ex
  puts "An error occurred:"
  p ex
end
sleep 4.0