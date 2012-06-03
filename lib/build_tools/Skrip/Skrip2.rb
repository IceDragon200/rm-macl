# // 04/16/2012
# // 04/17/2012
# // Skrip2
require 'zlib'
require 'iExRuby'
module Skrip
  FILE_EXTENSIONS = {
    "info"   => "skt",
    "script" => "skrip",
    "packed" => "skpck"
  }
  SUPPORTED_EXT = [".rb",".txt"]
  HEADER_TYPE_MLOAD = 0
  HEADER_TYPE_AUTOLOAD = 1
end
class << Skrip
  def str2skrip(str)
    Zlib.deflate(str)
  end
  def mk_skrip_hash_from_folder(location)
    files  = (Dir.entries(location) - [".",".."])
    files.select!{|s|Skrip::SUPPORTED_EXT.include?(File.extname(s))}
    file_a = files.collect do |f|
      [File.basename(f,File.extname(f)),File.read(location+f)]
    end  
    hsh_a  = file_a.collect do |a|
      [a[0],str2skrip(a[1])]
    end
    Hash[hsh_a]
  end
  def folder2skpck(src,trg,pout=true)
    filename = format("%s.%s",File.basename(src),Skrip::FILE_EXTENSIONS["packed"])
    skpck = Skrip.mk_skrip_hash_from_folder(src)
    if(pout)
      puts "skpck contents are:" 
      skpck.keys.sort.each do |f|
        puts format("-> %s", f)
      end
    end  
    hsh = mk_skrip_pack(skpck)
    loadord_fn = src+format("load_order.%s",Skrip::FILE_EXTENSIONS["info"])
    if(File.exist?(loadord_fn))
      puts "Found Load Order, autoload skpck is assumed"
      hsh[:header][:load_order] = File.read(loadord_fn).split(/[\r\n]+/i).collect{|s|s.gsub(/[\r\n]/,"").chomp}.select{|s|!(s=~/\/\//i)}
      puts "load order is : #{hsh[:header][:load_order]}"
      hsh[:header][:type] = Skrip::HEADER_TYPE_AUTOLOAD
    else
      puts "No Load Order found, normal skpck is assumed"
      hsh[:header][:type] = Skrip::HEADER_TYPE_MLOAD
    end  
    save_data(hsh, trg+filename)
    puts format("%s has been made successfully", filename) if(pout)
  end
  def mk_skrip_pack(skrip_hash)
    hsh = {}
    hsh[:header]  = {
      :build_time => Time.now.to_f,
      :type       => 0,
      :load_order => nil
    }
    hsh[:contents]= skrip_hash
    return hsh
  end  
end