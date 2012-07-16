$LOAD_PATH << "C:/Lib/iExRuby/"
require 'zlib'
require 'iExRuby'
 
def file2string(file)
  a = Req2File.import_require(file)
  puts a
  a[0]
end
def dumpstring(str)
  Zlib.deflate(str)
end
def make_skrip(file)
  dumpstring(file2string(file))
end
def read_folder(name)
  files = Dir.entries(name) - [".",".."]
  n = nil
  files.inject([]) do |r,fn|
    n = name+"/"+fn
    if(File.directory?(n))
      r += read_folder(n)
    else
      r.push(n);
    end
    r
  end
end
def make_skripack(location)
  n = read_folder(location)
  puts n
  r = nil
  h = Hash[n.collect{|fn|File.open(fn,"r"){|f|r=[fn,make_skrip(f)]};r}]
  puts h
  h
end
begin
  main = Dir.getwd
  $LOAD_PATH << main+"lib/"
  pack = {:header=>{},:content=>{}} # // Main
  #//
  pack[:header][:ruby_version] = RUBY_VERSION
  pack[:header][:pack_time] = Time.now.to_f
  pack[:content] = make_skripack("lib/")
  save_data(pack,"packed.skrpk")
end