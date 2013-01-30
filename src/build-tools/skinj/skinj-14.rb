class Skinj

  #
  # 0x14xxx+
  #

  #
  # parse(String str, Hash parameters)
  #
  # parameters
  #   String  :source
  #   Integer :line
  #
  def self.parse(str, parameters)
    lines = str.is_a?(Array) ? str.dup : str.split("\n")#(/[\n\r]+/)
    lines.collect! do |s| s.force_encoding('UTF-8') end

    # initialize Skinj instance
    skinj = Skinj.new(parameters)

    skinj.lines = lines

    skinj.parse_lines

  rescue Exception => ex
    write_skinj_error_log(skinj, ex)
  ensure
    return skinj
  end

  def self.write_skinj_error_log(skinj, ex)
    debug_puts '!!! >>>Skinj has crashed<<<'
    debug_puts ex.inspect

    Dir.mkdir 'skinj-crashes' unless Dir.exists?('skinj-crashes')

    File.open("skinj-crashes/#{Time.now.to_f*10**4}.log",?w) do |f|
      time_str = Time.now.strftime('%d/%m/%y %H:%M:%S')
      f.puts time_str
      f.puts "Error in file #{skinj.source} on line: #{skinj.index}"
      f.puts ex.inspect
      f.puts ex.backtrace
    end
  end

end
