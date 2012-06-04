=begin
 ──────────────────────────────────────────────────────────────────────────────
  Skinj (string assembler)
 ──────────────────────────────────────────────────────────────────────────────
  Date Created  : 05/12/2012
  Date Modified : 05/17/2012
  Version       : 0x10000
  Created By    : IceDragon
 ──────────────────────────────────────────────────────────────────────────────
  Change Log:
    05/17/2012
      Added inject
 ──────────────────────────────────────────────────────────────────────────────
  Asmbler Commands
    KEY
      [] optional
      <> defined
 ──────────────────────────────────────────────────────────────────────────────
    asmb_com - #-[x]<n>
      This is the basis to any Assembler Command.
      The line must start with #- in order to the command to be recoginized
      x - is the indent level of the command
      n - is the name of the command
 ──────────────────────────────────────────────────────────────────────────────
    include  - #-[x]include <n>
      Reads 'n' file into the current string, this can be used with other
      skinj strings to have nested inclusions.
 ──────────────────────────────────────────────────────────────────────────────
    inject   - #-[x]inject <n>
      Evaluates 'n' as a ruby string and includes the resulant string into the
      current string.
 ──────────────────────────────────────────────────────────────────────────────
    insert   - #-[x]insert <n>
      Converts a defined 'n' into the current string.
 ──────────────────────────────────────────────────────────────────────────────
    switch   - #-switch <n>:(ON|OFF|TOGGLE)
      Sets switch <n> with given state (on|off|toggle)
 ──────────────────────────────────────────────────────────────────────────────
    define_s - #-define <n>#=<y>
      Defines n as a string 'y'
 ──────────────────────────────────────────────────────────────────────────────
    define   - #-define <n>[=<y>]
      Defines 'n' with evaluated 'y'
 ──────────────────────────────────────────────────────────────────────────────
    undefine - #-undefine <n>
      Undefines 'n', and removes it
 ──────────────────────────────────────────────────────────────────────────────
    ifdef    - #-ifdef <n>
      If 'n' defined?
 ──────────────────────────────────────────────────────────────────────────────
    ifndef   - #-ifndef <n>
      If 'n' Not defined?
 ──────────────────────────────────────────────────────────────────────────────
    endif    - #-endif
      Pretty much
 ──────────────────────────────────────────────────────────────────────────────
    comment  - #-//<n>
      Ignored by assembler, used to make comments in skinj string.
 ──────────────────────────────────────────────────────────────────────────────
=end
$console_out = $stdout
Encoding.default_external = "UTF-8" # // Cause dumb shit happens otherwise
# ╒╕ ♥                                                                Skinj ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Skinj
  @@commands = []
  def self.add_command(sym,regexp,&block)
    nm = "asmb_" + sym.to_s
    @@commands << [sym,regexp,nm,block]
  end
  # // comment
  add_command :comment, /\A\/\/(.*)/i do 
    Skinj.debug_puts "Comment: %s" % params[1].to_s
    true
  end
  # // eval
  add_command :eval, /\Aeval\s(.+)/i do 
    Skinj.debug_puts "Eval: %s" % params[1]
    begin
      eval(params[1]) 
    rescue Exception => ex
      Skinj.debug_puts "Eval Failed: %s" % ex.message
    end  
    true
  end
  # // log
  add_command :log, /\Alog/i do
    Skinj.debug_puts 'Enable Log Mode'
    $stdout = File.open("Skinj#{Time.now.strftime("(%m-%d-%y)(%H-%M-%S)")}.log","w")
    $stdout.sync = true
  end
  # // Loads a file into the current Skinj
  add_command :include, /\A(?:\+\+|include)\s(.*)/i do 
    filename, = *sub_args(params[1])
    filename = filename.chomp.dump.gsub(/\A(?:['"])(.+)((?:['"]))/i) { $1 }
    Skinj.debug_puts "Including %s" % filename
    unless File.exist?(filename)
      Skinj.debug_puts "File %s does not exist, skipping." % filename 
      File.open("MissingFile.log","a") { |f| f.puts filename }
      sleep 2.0
    else  
      file  = File.open filename, "r"
      str   = file.read.chomp.strip
      file.close
      str   = Skinj.skinj_str(str,@define,@switches).compile
      strs  = str.split(/[\r\n]+/)
      strs.collect{|s|(" "*indent)+s}.each {|s| add_line(s) }
      Skinj.debug_puts "File %s included sucessfully" % filename
    end
    true
  end
  # // evaluates a string and loads it into the current Skinj
  add_command :inject, /\Ainject\s(.*)/i do 
    begin
      eval_string, = *sub_args(params[1])
      Skinj.debug_puts "Injecting %s" % eval_string
      str = eval eval_string 
      lines = str.split(/[\r\n]+/)
      lines.collect{|s|(" "*indent)+s}.each {|s| add_line(s) }
      true
    rescue(Exception) => ex
      Skinj.debug_puts "Inject failed: %s" % eval_string
      p ex
      true
    end  
  end
  # // load the contents of a defined const into the current Skinj
  add_command :insert, /\Ainsert\s(.*)/i do 
    begin
      key, = *sub_args(*params[1])
      Skinj.debug_puts "Inserting %s" % key
      str = @define[key]
      lines = str.split(/[\r\n]+/)
      lines.collect{|s|(" "*indent)+s}.each {|s| add_line(s) }
      true
    rescue(Exception) => ex
      Skinj.debug_puts "Insert failed: %s" % key
      p ex
      true
    end  
  end
  # // Switches
  add_command :switch, /\Aswitch\s(\S+):(ON|TRUE|OFF|FALSE|TOGGLE|FLIP)/i do 
    key,value = *sub_args(params[1],params[2])
    case value.upcase
    when "ON", "TRUE"
      @switches[key] = true
    when "OFF", "FALSE"
      @switches[key] = false
    when "TOGGLE", "FLIP"
      @switches[key] = !@switches[key]
    end
    Skinj.debug_puts "Switch %s = %s" % [key,@switches[key]]
    true
  end
  # // define const as string
  add_command :define_s, /\Adefine\s(\S+)\#\=(.+)/i do 
    key = params[1]
    value, = sub_args(params[2])
    @define[key] = value && !value.empty? ? value.to_s : ""
    Skinj.debug_puts "Defined [%s] = %s" % [key,@define[key]]
    true
  end
  # // define const
  add_command :define, /\Adefine\s(\S+)\=(.+)/i do 
    key = params[1]
    value, = sub_args(params[2])
    @define[key] = value && !value.empty? ? eval(value.to_s) : ""
    Skinj.debug_puts "Defined [%s] = %s" % [key,@define[key]]
    true
  end
  add_command :define2, /\Adefine\s(\S+):/i do
    key = params[1]
    @define[key] = "true"
    Skinj.debug_puts "Defined [%s] = %s" % [key,@define[key]]
    true
  end
  # // undefine const
  add_command :undefine, /\A(?:undefine|undef)\s(\S+)/i do
    key = params[1]
    Skinj.debug_puts "Undefining %s" % key
    @define.delete(key) 
    true
  end
  # // if defined?
  add_command :ifdef, /\A(?:if|unless(?:not|n))def\s(\S+)/i do 
    key = params[1]
    Skinj.debug_puts "If Defined: %s" % key
    !!@define[key] ? true : jump_to_end
  end
  # // if not defined?
  add_command :ifndef, /\A(?:if(?:not|n)|unless)def\s(\S+)/i do 
    key = params[1]
    Skinj.debug_puts "If Not Defined: %s" % key
    !@define[key] ? true : jump_to_end 
  end
  # // end if
  END_REGEX = /\Aend(?:if|unless|\:)/i
  END_REGEX_EX = /\#-end(?:if|unless|\:)/i
  RGX_ASMB_COM = /\A.?\#\-(\d+)?(.+)/i
  add_command :endif, END_REGEX do 
    Skinj.debug_puts "End Condition"
    true
  end
  def jump_to_end
    @index += 1 until @lines[@index] =~ END_REGEX_EX or @index >= @lines.size; true
  end 
  attr_accessor :index, :lines, :line
  def self.debug_puts(*args)
    str = args.collect{|obj|"<@skinj> "+obj.to_s}
    $console_out.puts str unless $console_out == $stdout
    puts str
  end
  def self.skinj_str(str,*args)
    skinj = new(*args)
    skinj.lines = str.split(/[\r\n]+/)
    skinj.index, skinj.line = 0, nil
    loop do 
      skinj.line = skinj.lines[skinj.index]
      break unless skinj.line
      skinj.index += 1
      if skinj.line =~ RGX_ASMB_COM
        i, n = ($1 || 0).to_i, $2
        com = skinj.execute_command(i,n)
        next if com
        #next if com.respond_to?(:call) ? instance_exec(&com) : true if com
      end  
      skinj.add_line skinj.line
      break if skinj.index >= skinj.lines.size
    end
  rescue Exception => ex
    File.open('Skinj_crash.log',"w+") { |f| 
      f.puts ex.message 
      f.puts ex.backtrace 
    }
  ensure
    return skinj  
  end
  def initialize(define={},switches={})
    @define = define
    @switches= switches
    @data = []
  end  
  def add_line(line)
    str, = incur_mode? ? sub_args(line) : line
    @data << str
  end  
  def get_define(str)
    @define[str]
  end
  def sub_args(*args)
    args.collect do |str|
      estr = str.dup
      @define.each_pair{|key,value|estr.gsub!(key,value.to_s)}
      estr
    end
  end  
  def params
    @last_params
  end
  def indent
    @last_indent
  end
  # // Assembler Commands
  def execute_command(indent,str)
    @last_params = nil
    @last_indent = indent
    @@commands.each do |a|
      symbol,regexp,asm_name,function = *a
      @last_params = str.match(regexp)
      return instance_exec(&function) if @last_params
    end
    return false
  end  
  # // Output
  def incur_mode?
    !!@switches["INCUR"]
  end
  def compile
    @data.join("\n")
  end
end
#------------------------------------------------------------------------------#
# // EOF
#------------------------------------------------------------------------------#