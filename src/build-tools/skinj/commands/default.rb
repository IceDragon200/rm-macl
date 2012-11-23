#encoding:UTF-8
#
# src/build_tools/skinj/commands/default.rb
#
class Skinj

  # // comment
  add_command :comment, REGEXP_COMMENT do
    debug_puts "COMMENT: %s" % params[1].to_s
    true
  end

  add_command :indent, REGEXP_INDENT do
    debug_puts "INDENT: %s%s" % params[1, 2]
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
    debug_puts "EVAL: %s" % params[1]
    begin
      eval(params[1])
    rescue Exception => ex
      debug_puts "Eval Failed: %s" % ex.message
    end
    true
  end

  # // log
  add_command :log, REGEXP_LOG do
    debug_puts 'LOG: ON'
    $stdout = File.open("Skinj#{Time.now.strftime("(%m-%d-%y)(%H-%M-%S-%L-%N)")}.log","w")
    $stdout.sync = true
  end

  # // Assembly Show
  add_command :asmshow, REGEXP_ASMSHOW do
    case params[1].upcase
    when "DEFINES"
      debug_puts 'Assembly Show: Definitions'
      debug_puts @definitionss.collect{|(key,value)|"<%s=%s>" % [key,value]}.join("\n")
    when "SWITCHES"
      debug_puts 'Assembly Show: Switches'
      debug_puts @switches.collect{|(key,value)|"<%s=%s>" % [key,value]}.join("\n")
    end
    true
  end

  add_command :wait, REGEXP_WAIT do
    time, = sub_args(params[1])
    debug_puts 'SLEEP: %s' % time
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
    debug_puts 'LABEL: %s' % params[1]
    true
  end

  add_command :build, REGEXP_TO_FILE do
    warn "Build has been removed since V1.50"
    #filename = params[:filename]
    #File.open filename, 'w:UTF-8' do |f|
    #  f.write self.assemble
    #end
  end

end
