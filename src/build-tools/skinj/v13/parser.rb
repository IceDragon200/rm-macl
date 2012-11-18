class Skinj

  # 
  # 0x13xxx-
  # 
  def self.skinj_str(str, *args)
    return warn("Version 1.3 functions have been disabled!")
    str = str.join "\n" if str.is_a? Array # // Reference protect
    skinj = self.allocate()
    skinj.initialize_v13(*args)
    skinj.lines = str.force_encoding('UTF-8').split(/[\r\n]/)
    skinj.index, skinj.line = 0, nil
    loop do
      skinj.line = skinj.lines[skinj.index]
      break unless skinj.line
      #skinj.line = ' ' if skinj.line.empty?
      skinj.index += 1
      if skinj.line =~ REGEXP_ASMB_COM
        i, n = ($1 || 0).to_i, $2
        com = skinj.execute_command(i, n)
        sleep $walk_command if $walk_command > 0 if com
        next if com
        #next if com.respond_to?(:call) ? instance_exec(&com) : true if com
      end
      skinj.add_line skinj.line
      break if skinj.index >= skinj.lines.size
    end
  rescue Exception => ex
    write_skinj_error_log(skinj, ex)
  ensure
    return skinj
  end

  def initialize_v13(indent=0, define={}, switches={}, records={}, macros=nil)
    @indent     = indent
    @definitions= define
    @switches   = switches
    @records    = records
    @macros     = macros
    @skj_indent = 0
    @branch     = []
    @data       = []
    setup_macros

    #debug_puts 'Skinj created: %s' % self.inspect
  end
  
end
