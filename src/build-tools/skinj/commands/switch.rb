class Skinj

  # // Switches
  add_command :switch, REGEXP_SWITCH do
    key,value = *sub_args(params[1], params[2])
    case value.upcase
    when "ON", "TRUE"
      @switches[key] = true
    when "OFF", "FALSE"
      @switches[key] = false
    when "TOGGLE", "FLIP"
      @switches[key] = !@switches[key]
    end
    debug_puts "SWITCH: %s = %s" % [key,@switches[key]]
    true
  end

end  
