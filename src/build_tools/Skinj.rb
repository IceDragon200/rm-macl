=begin
  DC : 05/12/2012
  DM : 05/17/2012
  VR : 0.1
  CL 
    05/17/2012
      Added inject
=end
class Skinj
  COMMANDS = {
    # // #++Lib/Ex.rb
    :include  => /(?:\+\+|include)[ ](.*)/i,     # // #-include filepath
    :inject   => /inject[ ](.*)/i,               # // #-inject eval_string
    :define   => /define[ ](\w+)(?:=(.+))?/i,    # // #-define const
    :undefine => /(?:undefine|undef)[ ](\w+)/i,  # // #-undefine const
    :ifdef    => /ifdef[ ](\S+)/i,               # // #-ifdef const
    :ifndef   => /ifndef[ ](\S+)/i,              # // #-ifndef const
    :endif    => /endif/i,                       # // #-endif
    :asmb_com => /\A\#\-(\d+)?(.+)/i ,           # // #-indentcommand
    :comment  => /\/\/(.*)/i                     # // #-//
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
      break unless line
      index += 1
      if line =~ COMMANDS[:asmb_com]
        i = $1 || 0
        n = $2
        case n
        when COMMANDS[:comment]
          puts "Comment: %s" % $1.to_s
          next
        when COMMANDS[:include]
          puts "Including %s" % $1
          skinj.asmb_include(i, *skinj.sub_args($1))
          next
        when COMMANDS[:inject]
          puts "Injecting %s" % $1
          skinj.asmb_inject(i, *skinj.sub_args($1))
          next
        when COMMANDS[:define]  
          puts "Defining %s" % $1
          skinj.asmb_define(i, *skinj.sub_args($1.to_s, $2.to_s)) 
          next
        when COMMANDS[:undefine]
          puts "Undefining %s" % $1
          skinj.asmb_undefine(i, *skinj.sub_args($1.to_s))
          next
        when COMMANDS[:ifdef]
          puts "if %s" % $1
          jump_to_next_end.call unless skinj.asmb_ifdef(i, *skinj.sub_args($1))
          next
        when COMMANDS[:ifndef]
          puts "if not %s" % $1
          jump_to_next_end.call if skinj.asmb_ifndef(i, *skinj.sub_args($1))
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
  # // Assembler Commands
  def asmb_include(indent,filename)
    unless File.exist?(filename)
      return puts "File %s does not exist, skipping." % filename 
    end
    file  = File.open filename, "r"
    str   = file.read
    file.close
    str   = Skinj.skinj_str(str,@defines).compile
    lines = str.split(/[\r\n]+/)
    lines.collect{|s|(" "*indent)+s}.each {|s| add_line(s) }
  end  
  def asmb_inject(indent,eval_string)
    str = eval eval_string rescue nil
    return puts "Inject failed: %s" % eval_string unless str
    lines = str.split(/[\r\n]+/)
    lines.collect{|s|(" "*indent)+s}.each {|s| add_line(s) }
  end
  def asmb_define(indent,key,value=nil)
    @defines[key] = value && !value.empty? ? eval(value) : ""
  end  
  def asmb_ifdef(indent,key)
    return !!@defines[key]
  end  
  def asmb_ifndef(indent,key)
    return !@defines[key]
  end  
  # // Output
  def compile
    @lines.join("\n")
  end
end
#------------------------------------------------------------------------------#
# // EOF
#------------------------------------------------------------------------------#