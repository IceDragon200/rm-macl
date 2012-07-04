begin
  infn,outf = ARGV[0,1]
  str = File.read infn
  File.open outf, ?w do |f|
    f.puts str.word_wrap(80)
  end
  gets
rescue Exception => ex
  p ex
  gets
end