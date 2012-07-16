class Skinj
  module Constants
    # // Base
    REGEXP_ASMB_COM   = /\#\-(\d+)?(.+)/i
    # // Commands
    REGEXP_COMMENT    = /\A\/\/(.*)/i
    REGEXP_INDENT     = /\Aindent\s([+-])?(\d+)/i
    REGEXP_EVAL       = /\Aeval\s(.+)/i
    REGEXP_LOG        = /\Alog:/i
    REGEXP_INCLUDE    = /\Ainclude\s(.+)/i
    REGEXP_INJECT     = /\Ainject\s(.+)/i
    REGEXP_INSERT     = /\Ainsert\s(.+)/i
    REGEXP_SWITCH     = /\Aswitch\s(\w+):(ON|TRUE|OFF|FALSE|TOGGLE|FLIP)/i
    REGEXP_UNDEF      = /\A(?:undefine|undef)\s(\w+)/i
    REGEXP_DEFINE     = /\Adefine\s(?<key>\w+)(?:\s*(?<param>[\#\&\|]{0,3})\=\s*(?<value>.+)|:?)/i
    REGEXP_IF         = /\A(?<cond>(?:if|unless))(?<mod>(?:not|n))?(?<def>def)?\s(?<value>.+)/i
    REGEXP_ELSE       = /\Aelse\:/i
    REGEXP_END        = /\Aend(?:if|unless|\:)/i
    REGEXP_SKIP       = /\Askip(?:\s(\d+)|\:)/i
    REGEXP_ASMSHOW    = /\Aasmshow\s(.+)/i
    REGEXP_WAIT       = /\Await\s(\d+.\d+)/i
    REGEXP_PRINT      = /\Aprint\s(.+)/i
    REGEXP_LABEL      = /\A(?:label|marker)\s(\w+)/i
    REGEXP_JUMP       = /\A(?:jumpto|jump)\s(?:(?<index>\d+|(?<label>\w+)))/i
    REGEXP_MACRO      = /\A(?:replay|macro)\s(\w+)/i
    REGEXP_MACRO_REC  = /\A(?:record|rec|append|apnd)(?:macro|mcr)?\s(\w+)/i
    REGEXP_MACRO_STOP = /\A(?:stop|stp)(?:macro|mcr)?\s(\w+)/i
    REGEXP_MACRO_CLEAR= /\A(?:clear|clr)(?:macro|mcr)\s(\w+)/i
    REGEXP_TO_FILE    = /\A(?:build|save|assemble)\sto\s(?<filename>.+)/i
    FOLD_OPN = [REGEXP_IF,REGEXP_SKIP,REGEXP_MACRO_REC]
    #/\A(?:(?:if|unless)(?:not|n)?def|skip|(?:rec|apnd|record|append)(?:macro|mcr))/i
  end
  include Constants
  @@commands = []
  def self.add_command sym,regexp,&block
    nm = "asmb_" + sym.to_s
    @@commands << [sym,regexp,nm,block]
  end
  # // comment
  add_command :comment, REGEXP_COMMENT do
    debug_puts "Comment: %s" % params[1].to_s
    true
  end
  add_command :indent, REGEXP_INDENT do
    debug_puts "Setting indent to %s%s" % params[1,2]
    param, value = params[1],params[2].to_i
    case params[1]
    when nil ; @indent  = value
    when "+" ; @indent += value
    when "-" ; @indent -= value
    end
    if @indent < 0
      @indent = 0
      debug_puts "Resetting indent to 0, due to negative value"
    end
    true
  end
  # // eval
  add_command :eval, REGEXP_EVAL do
    debug_puts "Eval: %s" % params[1]
    begin
      eval(params[1])
    rescue Exception => ex
      debug_puts "Eval Failed: %s" % ex.message
    end
    true
  end
  # // log
  add_command :log, REGEXP_LOG do
    debug_puts 'Enable Log Mode'
    $stdout = File.open("Skinj#{Time.now.strftime("(%m-%d-%y)(%H-%M-%S-%L-%N)")}.log","w")
    $stdout.sync = true
  end
  # // Loads a file into the current Skinj
  add_command :include, REGEXP_INCLUDE do
    filename, = *sub_args(params[1])
    filename = File.expand_path filename
    debug_puts "Including %s" % filename
    unless File.exist? filename
      debug_puts "File %s does not exist, skipping." % filename
      File.open "MissingFile.log","a" do |f|
        f.puts '%s >> %s' % [Time.now.strftime('%d-%m-%Y (%H:%M)'), filename]
      end
      #sleep 2.0
    else
      file  = File.open filename, "r"
      str   = file.read.chomp.strip
      file.close
      str   = Skinj.skinj_str(str,*settings).assemble
      strs  = str.split(/[\r\n]+/)
      strs.collect{|s|(" "*indent)+s}.each {|s| add_line(s) }
      debug_puts "File %s included sucessfully" % File.basename(filename)
    end
    true
  end
  # // evaluates a string and loads it into the current Skinj
  add_command :inject, REGEXP_INJECT do
    begin
      eval_string, = *sub_args(params[1])
      debug_puts "Injecting %s" % eval_string
      str = eval eval_string
      lines = str.split(/[\r\n]+/)
      lines.collect{|s|(" "*indent)+s}.each {|s| add_line(s) }
      true
    rescue(Exception) => ex
      debug_puts "Inject failed: %s" % eval_string
      p ex
      true
    end
  end
  # // load the contents of a defined const into the current Skinj
  add_command :insert, REGEXP_INSERT do
    begin
      key, = sub_args *params[1]
      debug_puts "Inserting %s" % key
      str = @define[key]
      lines = str.split(/[\r\n]+/)
      lines.collect{|s|(" "*indent)+s}.each {|s| add_line(s) }
      true
    rescue(Exception) => ex
      debug_puts "Insert failed: %s" % key
      p ex
      true
    end
  end
  # // Switches
  add_command :switch, REGEXP_SWITCH do
    key,value = *sub_args(params[1],params[2])
    case value.upcase
    when "ON", "TRUE"
      @switches[key] = true
    when "OFF", "FALSE"
      @switches[key] = false
    when "TOGGLE", "FLIP"
      @switches[key] = !@switches[key]
    end
    debug_puts "Switch [%s] = %s" % [key,@switches[key]]
    true
  end
  # // undefine
  add_command :undefine, REGEXP_UNDEF do
    key = params[1]
    debug_puts "Undefining %s" % key
    @define.delete key
    true
  end
  # // define with eval
  add_command :define, REGEXP_DEFINE do
    key         = params[:key]
    asgn_params = params[:param].to_s.split ''
    value,      = sub_args params[:value]||''
    setting = {
      asgn_or: asgn_params.count(?|),  # // 0 - no or, 1 - unary or, 2 - assign if or
      asgn_and: asgn_params.count(?&), # // 0 - no and, 1 - unary or, 2 - assign if or
      asgn_str: asgn_params.count(?#)  # // 0 - evaled, 1 - as string
    }
    if setting[:asgn_and] > 0   ; setting[:asgn_or] = 0
    elsif setting[:asgn_or] > 0 ; setting[:asgn_and] = 0
    end
    if setting[:asgn_str] ; res = value && !value.empty? ? value.to_s : ""
    else                  ; res = value && !value.empty? ? eval(value.to_s) : "" rescue nil
    end
    if setting[:asgn_and]    == 2 ; @define[key] &&= res
    elsif setting[:asgn_and] == 1 ; @define[key] &= res
    elsif setting[:asgn_or]  == 2 ; @define[key] ||= res
    elsif setting[:asgn_or]  == 1 ; @define[key] |= res
    else                          ; @define[key] = res
    end
    debug_puts "Defined [%s] = %s" % [key,@define[key]]
    true
  end
  # // if defined?
  add_command :if, REGEXP_IF do
    condition = params[:cond]
    mod_not   = !!params[:mod]
    as_def    = !!params[:def] # // As bool
    value     = params[:value]
    collapse_branch
    res = if as_def
      debug_puts '%s defined %s' % [condition.upcase,value]
      @define.has_key? value
    else
      begin
        debug_puts '%s %s' % [condition.upcase,value]
        eval value
      rescue Exception => ex
        debug_puts 'Error occured in the if evaluation'
        p ex
        false
      end
    end
    case condition.downcase
    when 'if'     ; res = !!res
    when 'unless' ; res = !res
    end
    res ? @branch[@skj_indent]=true : jump_to_else
  end
  # // end if
  add_command :end, REGEXP_END do
    debug_puts "End Condition"
    @branch[@skj_indent] = false
    true
  end
  add_command :else, REGEXP_ELSE do
    debug_puts 'Else'
    jump_to_end if @branch[@skj_indent]
    @branch[@skj_indent] = false
    true
  end
  add_command :skip, REGEXP_SKIP do
    collapse_branch
    if n=params[1] and !n.empty?
      debug_puts "Skip: %s lines" % n
      jump_to_rindex n.to_i
    else
      debug_puts "Skip: to next end"
      jump_to_next_end
    end
  end
  # // Assembly Show
  add_command :asmshow, REGEXP_ASMSHOW do
    case params[1].upcase
    when "DEFINES"
      debug_puts 'Assembly Show: Definitions'
      debug_puts @defines.collect{|(key,value)|"<%s=%s>" % [key,value]}.join("\n")
    when "SWITCHES"
      debug_puts 'Assembly Show: Switches'
      debug_puts @switches.collect{|(key,value)|"<%s=%s>" % [key,value]}.join("\n")
    end
    true
  end
  add_command :wait, REGEXP_WAIT do
    time, = sub_args(params[1])
    debug_puts 'Sleeping %s' % time
    sleep time.to_f
    true
  end
  add_command :print, REGEXP_PRINT do
    debug_puts 'PRINT: %s' % sub_args(params[1])
    true
  end
  add_command :jumpto, REGEXP_JUMP do
    params[:index] ? jump_to_index(params[:index], false) : jump_to_label(params[:label])
  end
  add_command :label, REGEXP_LABEL do
    debug_puts 'Label: %s' % params[1]
    true
  end
  # // Record Macro
  add_command :recmacro, REGEXP_MACRO_REC do
    name = params[1]
    debug_puts 'Recording Macro: %s' % name
    #@macros[:record] << params[1]
    collapse_branch
    jump_to_next_end do |line| 
      debug_puts ' >>>Collecting line: %s' % line
      macro_record name,line 
    end
    debug_puts 'Recorded Macro: %s' % name
    #collect_line do |line|
    #  unless command_line?(REGEXP_MACRO_STOP)
    #    debug_puts ' >>>Collecting line: %s' % line
    #    macro_record name,line
    #    false
    #  else ;
    #    debug_puts 'Recorded Macro: %s' % name
    #    true
    #  end
    #end
    #@index += 1
    #debug_puts @macros[:store][params[1]].inspect
    true
  end
  # // Stop Macro
  add_command :stopmacro, REGEXP_MACRO_STOP do
    debug_puts 'Stopping Macro record %s' % params[1]
    @macros[:record].delete params[1]
    true
  end
  # // Clear Macro
  add_command :clearmacro, REGEXP_MACRO_CLEAR do
    debug_puts "Clearing macro: %s" % params[1]
    @records[:store].delete params[1]
    true
  end
  # // Call Macro
  add_command :macro, REGEXP_MACRO do
    name = params[1]
    if @macros[:store][name]
      debug_puts ' >>>Macro: %s' % name
      list = @macros[:store][name]
      add_lines *Skinj.skinj_str(list,*settings).build
      debug_puts ' >>>Macro %s finished' % name
    else
      debug_puts 'Macro [%s] does not exist' % name
    end
    true
  end

  add_command :build, REGEXP_TO_FILE do
    filename = params[:filename]
    File.open filename, 'w:UTF-8' do |f|
      f.write self.assemble
    end
  end
end