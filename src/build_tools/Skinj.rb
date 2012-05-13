=begin
  DC : 05/12/2012
  DM : 05/12/2012
  VR : 0.1
=end
class Skinj
  COMMANDS = {
    # // #++Lib/Ex.rb
    :add_file => /(?:\+\+|add)[ ](.*)/i,         # // #-add filepath
    :define   => /define[ ](\w+)(?:=(.+))?/i,    # // #-define const
    :undefine => /(?:undefine|undef)[ ](\w+)/i,  # // #-undefine const
    :ifdef    => /ifdef[ ](\S+)/i,               # // #-ifdef const
    :ifndef   => /ifndef[ ](\S+)/i,              # // #-ifndef const
    :endif    => /endif/i,                       # // #-endif
    :comp_com => /\#\-(\d+)?(.+)/i               # // #-indentcommand
  }
  def self.skinj_str(str,*args)
    lines = str.split(/[\r\n]+/)
    skinj = new(*args)
    index, line = 0, nil
    jump_to_next_end = proc do
      index += 1 until lines[index] =~ /\#-endif/i || index >= lines.size
    end 
    loop do 
      line = lines[index]
      index += 1
      if line =~ COMMANDS[:comp_com]
        i = $1 || 0
        n = $2
        case n
        when COMMANDS[:add_file]
          puts "Adding %s" % $1
          skinj.comp_add_file(i, *skinj.sub_args($1))
          next
        when COMMANDS[:define]  
          puts "Defining %s" % $1
          skinj.comp_define(i, *skinj.sub_args($1.to_s, $2.to_s)) 
          next
        when COMMANDS[:undefine]
          puts "Undefining %s" % $1
          skinj.comp_undefine(i, *skinj.sub_args($1.to_s))
          next
        when COMMANDS[:ifdef]
          puts "if %s" % $1
          jump_to_next_end.call unless skinj.comp_ifdef(i, *skinj.sub_args($1))
          next
        when COMMANDS[:ifndef]
          puts "if not %s" % $1
          jump_to_next_end.call if skinj.comp_ifndef(i, *skinj.sub_args($1))
          next
        when COMMANDS[:endif]
          puts "end if"
          next
        end          
      end  
      skinj.add_line(line)
      break if index >= lines.size
    end
    skinj
  end
  def initialize(defines={})
    @defines = defines
    @lines = []
  end  
  def add_line(line)
    @lines << line
  end  
  def get_define(str)
    @defines[str]
  end
  def sub_args(*args)
    args.collect do |str|
      @defines.each_pair{|key,value|str = str.gsub(key,value)};str
    end
  end  
  # // Compiler Commands
  def comp_add_file(indent,filename)
    file  = File.open filename, "r"
    str   = file.read
    file.close
    str   = Skinj.skinj_str(str,@defines).compile
    lines = str.split(/[\r\n]+/)
    lines.collect{|s|(" "*indent)+s}.each {|s| add_line(s) }
  end  
  def comp_define(indent,key,value=nil)
    @defines[key] = value && !value.empty? ? eval(value) : ""
  end  
  def comp_ifdef(indent,key)
    return !!@defines[key]
  end  
  def comp_ifndef(indent,key)
    return !@defines[key]
  end  
  # // Output
  def compile
    @lines.join("\n")
  end
end