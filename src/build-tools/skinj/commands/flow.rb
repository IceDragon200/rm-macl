class Skinj
  
  def jump_to_else(with_else=true)
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

  def jump_to_next_end(&block)
    jump_to_else false, &block
  end

  def get_label_index(str, lines=@lines)
    debug_puts '>Finding label %s<' % str
    lines.index do |s|
      (n = command_line?(s)) ? (n[1] =~ REGEXP_LABEL ? $1 == str : false) : false
    end
  end

  def jump_to_label(str)
    debug_puts '>Jumping to label %s<' % str
    @index = get_label_index(str) || @lines.size
    true
  end

  def jump_to_index(index, silent=true)
    debug_puts '>Jumping to index %s<' % index unless silent
    n = (index-@index) <=> 0
    until @index == index
      debug_puts " >>Skipping: %s" % current_line
      @index += n
    end
    true
  end

  # // Relative Index
  def jump_to_rindex(index)
    jump_to_index @index + index
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
      @definitions.has_key? value
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
    
end
