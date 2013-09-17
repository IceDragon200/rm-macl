#
# rm-macl/lib/rm-macl/xpan/note_reader.rb
#
require 'rm-macl/macl-core'
module MACL
  class NoteReader

    attr_reader :rules

    FORMAT_DEFAULT   = '<%<name>s:\s*%<params>s>'.freeze
    FORMAT_KEY_VALUE = '<(%<name>s):\s*%<params>s>'.freeze # same as the default, but always grabs name
    TYPES_DEFAULT = {
      float:  '(\d+.\d+)',                                   # 1.0, 1.2, 1.3
      int:    '(\d+)',                                       # 1 2 3
      hex:    '((?:#|0x)(?:[A-F0-9]+))',                     # 0xFF22, #FF22
      number: '((?:#|0x)(?:[A-F0-9]+)|(?:\d+.\d+)|(?:\d+))', # *any of the above
      bool:   '(true|false)',                                # true false
      string: '\"([^\"]*)\"',                                # "Something :D"
      void:   '(.+)'                                         # anything goes here
    }.freeze

    @default_format = FORMAT_DEFAULT # <key: value>
    @default_types  = TYPES_DEFAULT

    def initialize(format=self.class.default_format, arg_join='\s*,\s*')
      @format = format
      @arg_join = arg_join
      @rules = []
      @type_partials = self.class.default_types.dup
      @regexp_option = "i"
    end

    def add_type(type_name, type_partial)
      @type_partials[type_name] = type_partial
      return self
    end

    def to_s
      "format[#{@format}] arg_joiner[#{@arg_join}] rule_count[#{@rules.size}]"
    end

    #
    # arg_types example
    # [:int, :int]
    # func(rule, params)
    def add_rule(name, *param_types, &func)
      rule   = { name: name.dup.freeze,
                 param_types: param_types.dup.freeze }.freeze
      regexp = mk_regexp_from_rule(rule)
      @rules.push([regexp, rule, func])
      return self
    end

    def match_rules(str)
      @rules.map do |(regexp, rule, func)|
        if mtch = str.match(regexp)
          params = mtch.to_a
          func.(rule, params) if func
          raw = params.shift
          { rule: rule, raw: raw, params: params }
        end
      end.compact
    end

  private

    def param_type_to_regex_partial(param_type)
      return @type_partials.fetch(param_type)
    end

    def mk_regexp_from_rule(rule)
      name, param_types = rule[:name], rule[:param_types]
      type_partials = param_types.map do |param_type|
        param_type_to_regex_partial(param_type)
      end
      str = @format % { name: name, params: type_partials.join(@arg_join) }
      return Regexp.new(str, @regexp_option)
    end

  public

    class << self

      attr_writer :default_types
      attr_writer :default_format

      def default_format
        @default_format || FORMAT_DEFAULT
      end

      def default_types
        @default_types || TYPES_DEFAULT
      end

    end

  end
end
MACL.register('macl/xpan/note_reader', '1.0.0')