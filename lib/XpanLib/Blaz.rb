# ╒╕ ♥                                                                 Blaz ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Blaz
  def initialize &block
    @commands = []
    instance_exec &block if block_given?
  end
  attr_accessor :commands
  def enum_commands
    sym,regex,func = [nil]*3
    @commands.each do |(sym,regex,func)|
      yield sym,regex,func
    end
  end  
  def add_command sym,regex,&func
    @commands << [sym,regex,func]
  end
  def match_command str
    enum_commands do |sym,regex,func|
      regex = regex.call if regex.respond_to? :call
      mtch = str.match(regex)
      return if yield sym, mtch, func if mtch
    end
  end
end