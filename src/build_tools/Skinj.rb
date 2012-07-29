=begin
 ──────────────────────────────────────────────────────────────────────────────
  Skinj (string assembler)
 ──────────────────────────────────────────────────────────────────────────────
  Date Created  : 05/12/2012
  Date Modified : 06/06/2012
  Version       : 0x13000
  Created By    : IceDragon
 ──────────────────────────────────────────────────────────────────────────────
=end
Encoding.default_external = "UTF-8" # // Cause dumb shit happens otherwise
begin
  require 'colorize' 
rescue LoadError
  class String
    def colorize sym
      self
    end
  end  
end  
require_relative '../standardlibex/Array_Ex.rb'
require_relative '../standardlibex/String_Ex.rb'
require_relative 'Skinj_commands.rb'
$console_out = $stdout #relay
#require_relative '../RelayIO.rb'
#relay = IO_Relay.new
#relay.add_relay $stdout
($imported||={})['Skinj'] = 0x12000
# ╒╕ ♥                                                                Skinj ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Skinj
  @@skinj_str = "<#{"SKINJ".colorize(:light_blue)} [#{"%04s".colorize(:light_red)}:#{"%02s".colorize(:light_green)}]> %s"
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
  $walk_command = 0.0
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
  def command_line? rgx,index=@index,lines=@lines
    mtch = lines[index].match REGEXP_ASMB_COM
    return false unless mtch
    return mtch[2].match rgx
  end
  def current_line
    @lines[@index]
  end
  def jump_to_next_end &block
    jump_to_else false,&block
  end
  def jump_to_else with_else=true
    org_index = @index
    @target_indent = @skj_indent
    @skj_indent += 1
    command = method(:command_line?)
    while true 
      break debug_puts 'EOF' if @index >= @lines.size
      if FOLD_OPN.any?(&command) #or command_line? REGEXP_INDENT
        @skj_indent += 1
      elsif command_line? REGEXP_END
        @skj_indent -= 1
      elsif with_else and command_line?(REGEXP_ELSE) and !@branch[@skj_indent]
        @skj_indent -= 1
      end
      yield current_line if block_given? unless @skj_indent == @target_indent
      jump_to_rindex 1
      break if @skj_indent == @target_indent
      raise "Negative indent at index %s" % @index if @skj_indent < 0
    end
    true
  end
  def get_label_index str,lines=@lines
    debug_puts '>Finding label %s<' % str
    lines.index do |s|
      (n = command_line?(s)) ? (n[1] =~ REGEXP_LABEL ? $1 == str : false) : false
    end
  end
  def jump_to_label str
    debug_puts '>Jumping to label %s<' % str
    @index = get_label_index(str) || @lines.size
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
  def self.skinj_str str,*args
    str = str.join "\n" if str.is_a? Array # // Reference protect
    skinj = new *args
    skinj.lines = str.force_encoding('UTF-8').split(/[\r\n]/)
    skinj.index, skinj.line = 0, nil
    loop do
      skinj.line = skinj.lines[skinj.index]
      break unless skinj.line
      #skinj.line = ' ' if skinj.line.empty?
      skinj.index += 1
      if skinj.line =~ REGEXP_ASMB_COM
        i, n = ($1 || 0).to_i, $2
        com = skinj.execute_command(i,n)
        sleep $walk_command if $walk_command > 0 if com
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
  def setup_imported 
    rgx = /\(\$imported\|\|\=\{\}\)\['(.+)'\]=(\S+)/i
    imports = @data.select do |s| s =~ rgx end
    @data.delete_if do |s| s =~ rgx end
    matches = imports.collect do |s| s.match(rgx) end.compact 
    length  = matches.max_by do |mtd| mtd[1].length end[1].length + 2
    str = matches.collect do |mtd| 
      %Q(%-0#{length}s => #{mtd[2]}) % "'#{mtd[1]}'" 
    end.sort#.join("\n")
    str.collect! do |s| s.indent(2) end
    str = str.join(",\n")
    fstr = %Q(($imported||={}).merge!(\n#{str}\n)).split(/[\r\n]/)
    add_lines *fstr
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