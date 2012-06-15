# // 04/21/2012
# // 04/21/2012
$LOAD_PATH << "C:/Lib/iExRuby"
require 'iExRuby'
FILE_EXTS = [".txt",".ini",".inf",".rb"]
def File.bsnm_ext(str)
  File.basename(str,File.extname(str))
end
def file2a(fn)
  File.read(fn).split(/[\r\n]+/i)
end
def mk_dir_struct(name)
  files = Dir.entries(name) - [".",".."]
  files = (files.collect{|f|name+f}).select{|f|
    (!File.directory?(f)) ? FILE_EXTS.any?{|ext|File.extname(f).downcase == ext.downcase} : true
  }
  files.inject({}) do |r,f|
    if(File.directory?(f)) 
      r[[:branch,File.bsnm_ext(f)]] = mk_dir_struct(f+"/")
    else
      r[[:leaf,File.bsnm_ext(f)]] = File.read(f)
    end 
    r
  end
end
def puts_hsh_fold_struct(hsh,ind=0)
  str = ""
  hsh.each_pair { |k,v|
    case(k[0])
    when :leaf
      str += ("  "*ind) + k[1] + "\n"
    when :branch
      str += puts_hsh_fold_struct(v,ind+1)
    end
  }
  str
end
begin
  source,= ARGV
  source = source.dup.gsub("\\","/")
  target = source + '/../'
  hsh = mk_dir_struct(source+"/")
  save_data(hsh,target+File.bsnm_ext(source)+".strtb")
  puts puts_hsh_fold_struct(hsh)
  #puts hsh
end