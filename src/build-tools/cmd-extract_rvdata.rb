#enconding:UTF-8
=begin

  build_tools/cmd-scripts_extract.rb
  by IceDragon
  dc 05/01/2012
  dm 26/10/2012
  vr <const VERSION>

=end

Encoding.default_external = Encoding.default_internal = "UTF-8"

##
# module Kernel
#
module Kernel

  def load_data(filename)
    obj = nil;
    File.open(filename, 'rb') { |f| obj = Marshal.load(f); };
    return obj;
  end

  def save_data(obj, filename)
    File.open(filename, 'wb') { |f| Marshal.dump(obj, f) };
    return obj;
  end

end

require 'zlib'

VERSION = "1.01"

CHAR_NEWLINE = "\n"

HELP_STR = %Q(
/*
  Script Extractor V#{VERSION}
  by IceDragon
 */
 
  -src <filename>
    Sets the file source

  -dest <pathname>
    Set the extraction destination
    The folder will be created if it does not exist

)

##
# set_default_settings(Hash<Symbol, String> settings)
#
def set_default_settings(settings)
  settings[:src]  = File.expand_path("Data/Scripts.rvdata2")
  settings[:dest] = File.expand_path("Scripts/")
  return settings
end

##
# File.sanitize_filename(String filename)
#
def File.sanitize_filename(filename)
  #filename.strip.chomp.gsub(/[\>\<\:\;\\\/\|\*\?\"\'\!\,\^\%\$\#\@\~\`]/,?_)
  filename.gsub(/[^0-9A-Za-z.\-\_]/) { $1 }
end

##
# main(String[] argsv)
#
def main(argsv)

  if argsv.empty?
    puts HELP_STR
    return
  end

  settings = Hash.new
  set_default_settings(settings)

  while(arg = argsv.shift)
    case arg
    when '-d'
      set_default_settings(settings)
      puts 'Running with default settings'
    # Set filepath source
    when '--src'
      settings[:src] = argsv.shift
    # Set the destination/target directory/file  
    when '--dest'
      settings[:dest] = argsv.shift
    else
      raise(ArgumentError, "Invalid Command: #{arg}")
    end
  end

  src  = settings[:src]
  dest = settings[:dest]

  Dir.mkdir(dest) unless Dir.exist?(dest)

  puts 'Extracting'

  scripts = load_data(src)

  i = 0
  for (checksum, name, zstr) in scripts 
    puts "Processing [#{"%04d" % i}]#{name}"  
    fn = ("[%04d]%s.%s" % [i, File.sanitize_filename(name), "rb"])
    fn = File.join(dest, fn)
    File.open(fn, "w+") do |f|
      str = Zlib.inflate(zstr)
      str.gsub!(/[\r\n]/i, CHAR_NEWLINE) # Replace /r/n with /n
      str.gsub!(/(\n\n)/i, CHAR_NEWLINE) # Fixes a weird doubleline error when inflating strings
      f.write("# #{name}\n" + str.force_encoding("UTF-8"))
    end
    i += 1
  end

  puts 'Extraction Complete'

end

begin
  main(ARGV.dup)
rescue(Exception) => ex
  raise ex
end
