#
# RGSS3-MACL/lib/xpan-lib/notereader.rb
#   by IceDragon
#   dc 21/03/2013
#   dm 21/03/2013
# vr 0.1.0
module MACL
class NoteReader

  attr_reader :rules

  def initialize(format='<%<name>s:\s*%<params>s>', arg_join='\s*,\s*')
    @format = format
    @arg_join = arg_join
    @rules = []
    @type_partials = {
      int:    '(\d+)',        # 1 2 3
      bool:   '(true|false)', # true false
      string: '\"([^\"]*)\"', # "Something :D"
      void:   '(.*)'          # anything goes here
    }
  end

  def add_type(type_name, type_partial)
    @type_partials[type_name] = type_partial
  end

  def to_s
    "format[#{@format}] arg_joiner[#{@arg_join}] rule_count[#{@rules.size}]"
  end

  #
  # arg_types example
  # [:int, :int]
  # func(rule, params)
  def add_rule(name, *param_types, &func)
    rule   = [name, param_types]
    regexp = mk_regexp(*rule)
    @rules.push([regexp, rule, func])
  end

  def match_rules(line)
    @rules.collect do |(regexp, rule, func)|
      if mtch = line.match(regexp)
        params = mtch.to_a
        func.(rule, params) if func
        params
      end
    end.compact
  end

private

  def param_type_to_regex_partial(param_type)
    type_partial = @type_partials[param_type]
    raise(ArgumentError, "Inavlid param_type #{param_type}") unless type_partial
    return type_partial
  end

  def mk_regexp(name, param_types)
    type_partials = param_types.map { |param_type|
                                      param_type_to_regex_partial(param_type) }
    str = @format % { name: name, params: type_partials.join(@arg_join) }
    return Regexp.new(str, 'i')
  end

end
end
