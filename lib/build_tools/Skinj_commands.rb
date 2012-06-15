class Skinj
  @@commands = []
  def self.add_command(sym,regexp,&block)
    nm = "asmb_" + sym.to_s
    @@commands << [sym,regexp,nm,block]
  end  
  RGX_ASMB_COM = /\#\-(\d+)?(.+)/i
  REGEX_INDENT = /\A(?:if|unless)(?:not|n)?def\s(\S+)/i
  REGEX_END    = /\Aend(?:if|unless|\:)/i
  REGEX_ELSE   = /\Aelse\:/i
  REGEX_MACRO_STOP = /\A(?:stop|stp)(?:macro|mcr)\s(\S+)/i
  REGEX_MACRO_REC = /\A(?:record|rec)(?:macro|mcr)\s(\S+)/i
  # // comment
  add_command :comment, /\A\/\/(.*)/i do 
    debug_puts "Comment: %s" % params[1].to_s
    true
  end
  add_command :indent, /\Aindent\s([+-])?(\d+)/i do
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
  add_command :eval, /\Aeval\s(.+)/i do 
    debug_puts "Eval: %s" % params[1]
    begin
      eval(params[1]) 
    rescue Exception => ex
      debug_puts "Eval Failed: %s" % ex.message
    end  
    true
  end
  # // log
  add_command :log, /\Alog/i do
    debug_puts 'Enable Log Mode'
    $stdout = File.open("Skinj#{Time.now.strftime("(%m-%d-%y)(%H-%M-%S-%L-%N)")}.log","w")
    $stdout.sync = true
  end
  # // Loads a file into the current Skinj
  add_command :include, /\A(?:\+\+|include)\s(.+)/i do 
    filename, = *sub_args(params[1])
    filename = filename
    debug_puts "Including %s" % filename
    unless File.exist?(filename)
      debug_puts "File %s does not exist, skipping." % filename 
      File.open("MissingFile.log","a") { |f| f.puts filename }
      #sleep 2.0
    else  
      file  = File.open filename, "r"
      str   = file.read.chomp.strip
      file.close
      str   = Skinj.skinj_str(str,*settings).compile
      strs  = str.split(/[\r\n]+/)
      strs.collect{|s|(" "*indent)+s}.each {|s| add_line(s) }
      debug_puts "File %s included sucessfully" % File.basename(filename)
    end
    true
  end
  # // evaluates a string and loads it into the current Skinj
  add_command :inject, /\Ainject\s(.+)/i do 
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
  add_command :insert, /\Ainsert\s(.+)/i do 
    begin
      key, = *sub_args(*params[1])
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
    debug_puts "Switch [%s] = %s" % [key,@switches[key]]
    true
  end
  # // undefine const
  add_command :undefine, /\A(?:undefine|undef)\s(\S+)/i do
    key = params[1]
    debug_puts "Undefining %s" % key
    @define.delete(key) 
    true
  end
  # // define const as string
  add_command :define_s, /\Adefine\s(\S+)\#\=(.+)/i do 
    key = params[1]
    value, = sub_args(params[2])
    @define[key] = value && !value.empty? ? value.to_s : ""
    debug_puts "Defined [%s] = %s" % [key,@define[key]]
    true
  end
  # // define const
  add_command :define, /\Adefine\s(\S+)\=(.+)/i do 
    key = params[1]
    value, = sub_args(params[2])
    @define[key] = value && !value.empty? ? eval(value.to_s) : "" rescue nil
    debug_puts "Defined [%s] = %s" % [key,@define[key]]
    true
  end
  add_command :define2, /\A(?:define|def)\s(\S+)/i do
    key = params[1]
    @define[key] = "true"
    debug_puts "Defined [%s] = %s" % [key,@define[key]]
    true
  end
  # // if defined?
  add_command :ifdef, /\A(?:if|unless(?:not|n))def\s(\S+)/i do 
    key = params[1]
    debug_puts "If Defined: %s" % key
    @branch.replace(@branch[0,@skj_indent])
    #@skj_indent += 1
    @define[key] ? @branch[@skj_indent]=true : jump_to_else
  end
  # // if not defined?
  add_command :ifndef, /\A(?:if(?:not|n)|unless)def\s(\S+)/i do 
    key = params[1]
    debug_puts "If Not Defined: %s" % key
    @branch.replace(@branch[0,@skj_indent])
    #@skj_indent += 1
    @define[key] ? jump_to_else : @branch[@skj_indent]=true
  end
  # // end if
  add_command :endif, REGEX_END do 
    debug_puts "End Condition"
    @branch[@skj_indent] = false
    true
  end
  add_command :else, /\Aelse\:/i do
    debug_puts 'Else'
    jump_to_end if @branch[@skj_indent]
    @branch[@skj_indent] = false
    true
  end
  # // Assembly Show
  add_command :asmshow, /\Aasmshow\s(.+)/i do 
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
  add_command :wait, /\Await\s(\d+.\d+)/i do
    time, = sub_args(params[1])
    debug_puts 'Sleeping %s' % time
    sleep time.to_f
    true
  end
  add_command :print, /\Aprint\s(.+)/i do
    debug_puts 'PRINT: %s' % sub_args(params[1])
    true
  end
  add_command :jumpto, /\A(?:jumpto|jump)\s(\S+)/i do
    debug_puts '>Jumping to %s<' % params[1]
    jump_to_label params[1]
  end
  add_command :label, /\Alabel\s(\S+)/ do
    debug_puts 'Label: %s' % params[1]
    true
  end
  # // Record Macro
  add_command :recmacro, REGEX_MACRO_REC do
    name = params[1]
    debug_puts 'Recording Macro: %s' % name
    #@macros[:record] << params[1]
    collect_line do |line|
      unless command_line?(REGEX_MACRO_STOP)
        debug_puts ' >>>Collecting line: %s' % line
        macro_record name,line
        false
      else ; 
        debug_puts 'Recorded Macro: %s' % name
        true  
      end
    end 
    @index += 1
    #debug_puts @macros[:store][params[1]].inspect
    true
  end
  # // Stop Macro
  add_command :stopmacro, REGEX_MACRO_STOP do
    debug_puts 'Stopping Macro record %s' % params[1]
    @macros[:record].delete(params[1])
    true
  end
  # // Clear Macro
  add_command :clearmacro, /\A(?:clear|clr)(?:macro|mcr)\s(\S+)/i do
    debug_puts "Clearing macro: %s" % params[1]
    @records[:store].delete(params[1])
    true
  end
  # // Call Macro
  add_command :macro, /\Amacro\s(\S+)/i do
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
end