=begin
  chardoc/chardoc.rb
=end
begin
  require 'colorize'
rescue LoadError  
  class String
    def colorize sym
      self
    end
  end
end

begin
  # //

# // Catch the annoying stuff
rescue Exception => ex
  p ex
  puts ex.backtrace
end
puts 'Press return to continue'
gets