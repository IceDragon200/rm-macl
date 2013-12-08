require_relative 'common.rb'

linara = MACL::Linara.new
linara.add('test/linara', 0) do
  puts "Hello World"
end
linara.log = STDERR
linara.run