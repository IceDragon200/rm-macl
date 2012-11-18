class Skinj

  # // Loads a file into the current Skinj
  add_command :include, REGEXP_INCLUDE do

    filename, = *sub_args(params[1])
    filename = File.expand_path(filename)

    unless File.exist?(filename)
      debug_puts "File %s does not exist, skipping." % filename

      File.open("skinj-missingfiles.log", "a") do |f|
        f.puts '%s >> %s' % [Time.now.strftime('%d-%m-%Y (%H:%M)'), filename]
      end
      #sleep 2.0
    else
      debug_puts "Including %s" % filename

      str = File.read(filename)

      new_settings = settings()
      new_settings[:source] = filename
      new_settings[:index] = 0

      str   = Skinj.parse(str, new_settings).assemble
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
      str = @definitions[key]
      lines = str.split(/[\r\n]+/)
      lines.collect{|s|(" "*indent)+s}.each {|s| add_line(s) }
      true
    rescue(Exception) => ex
      debug_puts "Insert failed: %s" % key
      p ex
      true
    end
  end

end  
