=begin
 ──────────────────────────────────────────────────────────────────────────────
  Skinj (string assembler)
 ──────────────────────────────────────────────────────────────────────────────
  Date Created  : 05/12/2012
  Date Modified : 06/06/2012
  Version       : 0x10000
  Created By    : IceDragon
 ──────────────────────────────────────────────────────────────────────────────
  Change Log:
    05/17/2012
      Added inject
    06/04/2012
      Added support for nested conditions
      Added new command(s):
        wait <float>
          Puts skinj to sleep for <float> seconds
        print <str>
          Tells Skinj to print a message to the console
        label <str>
          Doesnt operate
        jumpto <str>
          Jumps to a given 'label' <str>
        asmshow <str>
    06/04/2012
      Added new command(s):
        indent +/-<int>
        recmacro <str>
        clrmacro <str>
        stopmacro <str>
        macro <str>
 ──────────────────────────────────────────────────────────────────────────────
=end
Encoding.default_external = "UTF-8" # // Cause dumb shit happens otherwise
# ╒╕ ♥                                                                Skinj ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
#require_relative '../RelayIO.rb'
#relay = IO_Relay.new
#relay.add_relay $stdout
require 'Iconv'
require_relative '../StandardLibEx/Array_Ex.rb'
require_relative '../StandardLibEx/String_Ex.rb'
require_relative 'Skinj_commands.rb'
$console_out = $stdout #relay
($imported||={})['Skinj'] = 0x1000A
class Skinj
  def collect_line
    res = (@index...@lines.size).collect do |i|
      @index = i
      break if yield current_line
      current_line
    end
    res
  end
  def setup_macros
    @macros ||= {}
    @macros[:record] ||= []
    @macros[:store] ||= {}
    @macros
  end
  def macro_record name,str
    (@macros[:store][name]||=[]) << str
  end
  def command_line? rgx
    mtch = @lines[@index].match REGEXP_ASMB_COM
    return false unless mtch
    return mtch[2].match rgx
  end
  def current_line
    @lines[@index]
  end
  def jump_to_next_end
    jump_to_else false
  end
  def jump_to_else with_else=true
    org_index = @index
    @target_indent = @skj_indent
    @skj_indent += 1
    while true
      break debug_puts 'EOF' if @index >= @lines.size
      if command_line? REGEXP_INDENT
        @skj_indent += 1
      elsif command_line? REGEXP_END
        @skj_indent -= 1
      elsif with_else and command_line?(REGEXP_ELSE) && !@branch[@skj_indent]
        @skj_indent -= 1
      end
      jump_to_rindex 1
      break if @skj_indent == @target_indent
      raise "Negative indent at index %s" % @index if @skj_indent < 0
    end
    true
  end
  def jump_to_label str
    debug_puts '>Jumping to label %s<' % str
    lookup = /\A\#-label #{str}/i
    @index = @lines.index do |s|
      !!(s =~ lookup)
    end
    @index ||= @lines.size
    true
  end
  def jump_to_index index,silent=true
    debug_puts '>Jumping to index %s<' % index unless silent
    n = (index-@index) <=> 0
    until @index == index
      debug_puts " >>Skipping: %s" % current_line
      @index += n
    end
    true
  end
  # // Relative Index
  def jump_to_rindex index
    jump_to_index @index + index
  end
  @@skinj_str = "<"
  @@skinj_str += "SKINJ"#.green
  @@skinj_str += " line"#.light_green
  @@skinj_str += "[%04s]"#.light_white
  @@skinj_str += " indent"#.light_green
  @@skinj_str += "[%02s]"#.light_white
  @@skinj_str += "> %s"
  def debug_puts *args,&block
    str = args.collect{|obj|@@skinj_str % [@index,@skj_indent,obj.to_s]}
    Skinj.skinj_puts *str,&block
  end
  def self.debug_puts *args,&block
    str = args.collect{|obj|"<@skinj> %s" % obj.to_s}
    skinj_puts *str,&block
  end
  def self.skinj_puts *args, &block
    $console_out.puts *args,&block unless $console_out == $stdout
    puts *args,&block
  end
  def self.skinj_str str,*args
    str = str.join "\n" if str.is_a? Array # // Reference protect
    skinj = new *args
    ic = Iconv.new 'UTF-8//IGNORE', 'UTF-8'
    skinj.lines = ic.iconv(str).split(/[\r\n]+/)
    skinj.index, skinj.line = 0, nil
    loop do
      skinj.line = skinj.lines[skinj.index]
      break unless skinj.line
      skinj.index += 1
      if skinj.line =~ REGEXP_ASMB_COM
        i, n = ($1 || 0).to_i, $2
        com = skinj.execute_command(i,n)
        next if com
        #next if com.respond_to?(:call) ? instance_exec(&com) : true if com
      end
      skinj.add_line skinj.line
      break if skinj.index >= skinj.lines.size
    end
  rescue Exception => ex
    debug_puts '>>>Skinj has crashed<<<'
    debug_puts ex.inspect
    Dir.mkdir 'crashes' unless File.exists? 'crashes'
    File.open("crashes/#{Time.now.to_f*10**4}.log",?w) do |f|
      f.puts [skinj.index]
      f.puts ex.message
      f.puts ex.backtrace
    end
  ensure
    return skinj
  end
  attr_accessor :index, :lines, :line, :indent, :skj_indent, :records, :macros
  def initialize indent=0,define={},switches={},records={},macros=nil
    @indent     = indent
    @define     = define
    @switches   = switches
    @records    = records
    @macros     = macros
    @skj_indent = 0
    @branch     = []
    @data       = []
    setup_macros

    #debug_puts 'Skinj created: %s' % self.inspect
  end
  def settings
    return @indent,@define,@switches,@records,@macros
  end
  def add_line line
    str, = incur_mode? ? sub_args(line) : line
    @data << str
  end
  def add_lines *lines
    lines.each do |str| add_line str end
  end
  def get_define str
    @define[str]
  end
  def sub_args *args
    args.collect do |str|
      estr = str.dup
      @define.each_pair { |key,value|estr.gsub!(key,value.to_s) }
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
  def execute_command indent,str
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
  def build
    @data.invoke_collect :indent,@indent
  end
  def assemble
    build.join "\n"
  end
  # // Trim the @branch array to fit the current indent level
  def collapse_branch
    @branch.replace @branch[0,@skj_indent]
  end
end
#------------------------------------------------------------------------------#
# // EOF
#------------------------------------------------------------------------------#