=begin
class Skinj

  # // define with eval
  add_command :define_13, REGEXP_DEFINE_13 do
    key         = params[:key]
    asgn_params = params[:param].to_s.split('')
    value,      = sub_args(params[:value] || '')

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

    if setting[:asgn_and]    == 2 ; @definitions[key] &&= res
    elsif setting[:asgn_and] == 1 ; @definitions[key] &= res
    elsif setting[:asgn_or]  == 2 ; @definitions[key] ||= res
    elsif setting[:asgn_or]  == 1 ; @definitions[key] |= res
    else                          ; @definitions[key] = res
    end

    debug_puts "Defined [%s] = %s" % [key, @definitions[key]]
    true
  end

end
=end
