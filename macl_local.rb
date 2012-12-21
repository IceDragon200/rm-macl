#
# macl_local.rb
#
require 'colorize'

module MACL

  def self.local_path(filename)
    File.dirname(filename)
  end

  def self.linara_add(filename, array)
    puts ">!!".colorize(:light_yellow)  + " parameter(#{'array'.colorize(:light_yellow)}) is ignored all files will be loaded instead"
    array = Dir.glob(File.join(File.dirname(filename), '*.rb'))
    array = array.collect(&File.method(:basename)) - ['_build_order.rb', '_local_require.rb']
    array.sort!
    array.collect! do |s| [s, 0] end
    $alinara += array.collect do |(s, p)|
      [File.join(File.expand_path(File.dirname(filename)), s), p]
    end
  end

end

def local_require_with_rescue(filename)
  require_relative filename
  result = "$ #{filename}"
rescue(Exception) => ex
  #result = "! #{filename}\n#{ex.inspect}"
  raise ex
#ensure
  #puts pstr
  #return result
end

file_path = File.dirname(__FILE__)
path = file_path + '/src/**/_local_require.rb'

last_load = File.open(File.join(file_path, 'last_load.log'), 'w+')
last_load.sync = true
last_load.write(Time.now.strftime('%m %d, %y - %H:%M:%S') + "\n")

$alinara = [] # [filename, priority]

#puts '>>$ Preparing'
Dir[path].sort.each do |s|
  last_load.write(local_require_with_rescue(s) + "\n")
end

#puts '>>$ Linara style load'

$alinara = $alinara.sort_by do |(filename, priority)| priority end
$alinara.each do |(filename, priority)|
  last_load.write(local_require_with_rescue(filename) + "\n")
end
