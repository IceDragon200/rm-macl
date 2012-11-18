#
# src/build-tools/skinj/skinj-static.rb
#
class Skinj

  @@skinj_str = "<#{"SKINJ".colorize(:light_blue)}: #{"%-20s".colorize(:orange)} [#{"%04s".colorize(:light_red)}:#{"%02s".colorize(:light_green)}]> %s"

  def self.debug_puts(*args, &block)
    str = args.collect { |obj| "<@skinj> %s" % obj.to_s }
    skinj_puts *str,&block
  end

  def self.skinj_puts(*args, &block)
    console.puts *args,&block unless console == $stdout
    puts *args,&block
  end

end  
