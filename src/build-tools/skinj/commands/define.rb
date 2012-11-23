class Skinj

  def skj_defined?(key)
    bool = @definitions.has_key?(key)
    warn("#{key} was already defined!") if bool
    return bool
  end

  def puts_defined(key)
    debug_puts "DEFINE: #{key.colorize(:yellow)} = #{@definitions[key].to_s.colorize(:light_magenta)}"
  end

  # // undefine
  add_command :undefine, REGEXP_UNDEF do
    key = params[1]
    debug_puts "Undefining %s" % key
    @definitions.delete(key)
    true
  end

  DefFunc = Struct.new(:key, :params, :value)

  add_command(:define_func, REGEXP_DEFINE_FUNC) do
    key         = params[:key]
    paramz      = params[:param].split(/\s*,\s*/)
    value,      = sub_args(params[:value])
    skj_defined?(key)
    @definitions[key] = DefFunc.new(key, paramz, value)

    puts_defined(key)
    true
  end

  # define key value
  add_command(:define_rpl, REGEXP_DEFINE_RPL) do
    key         = params[:key]
    value,      = sub_args(params[:value])
    skj_defined?(key)
    @definitions[key] = value
    
    puts_defined(key)
    true
  end

  # define key
  add_command(:define, REGEXP_DEFINE) do
    key         = params[:key]
    skj_defined?(key)
    @definitions[key] = ""
    
    puts_defined(key)
    true
  end

end
