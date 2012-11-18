class Skinj

  def setup_macros
    @macros ||= {}
    @macros[:record] ||= []
    @macros[:store] ||= {}
    @macros
  end

  def macro_record(name, str)
    (@macros[:store][name]||=[]) << str
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
  
end
