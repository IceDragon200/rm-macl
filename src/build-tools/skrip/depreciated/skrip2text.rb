# // 04/21/2012
# // 04/21/2012
$LOAD_PATH << "C:/Lib/iExRuby/"
require 'Skrip2'
require 'Skrip2_reader'

begin
  Dir.mkdir "C:/Lib/skpck2out/" unless File.exist? "C:/Lib/skpck2out/"
  source, = args
  source = source.dup.gsub "\\","/"
  File.open(File.basename(source,File.extname(source))+".rb", "w+") { |f| f.puts(Skrip.skrip2str(load_data(source)) }
end