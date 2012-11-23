#
# src/build-tools/skinj/skinj-instance.rb
#
class Skinj

  attr_accessor :index, :lines, :indent, :skj_indent, 
                :records, :macros
  attr_reader :source

  def initialize(settings)
    @source      = settings[:source] || "<UNKNOWN>"
    @indent      = settings[:indent] || 0
    @definitions = settings[:definitions] || {}
    @switches    = settings[:switches] || {}
    @records     = settings[:records] || {}
    @macros      = settings[:macros] || {}
    @index       = settings[:index] || 0
    @skj_indent  = 0
    @branch      = []
    @data        = []
    setup_macros

    # This files current filename
    @definitions['__THISFILE__'] = File.basename(@source)
    # This files current directory name
    @definitions['__THISDIR__'] = File.dirname(@source)
  end

  def debug_puts(*args, &block)
    fn = File.basename(@source)
    str = args.collect{ |obj|
      @@skinj_str % [fn, @index, @skj_indent,obj.to_s]
    }
    Skinj.skinj_puts(*str, &block)
  end

  def line_count
    @lines.size
  end

  def prev_line
    self.index -= 1
  end

  def next_line
    self.index += 1
  end

  def each_line
    while index < line_count
      yield current_line
      next_line
    end
  end

  def collect_line
    res = (@index...@lines.size).collect do |i|
      @index = i
      break if yield current_line
      current_line
    end
    res
  end

  def get_line(index)
    return @lines[index] || ""
  end

  def current_line
    return get_line(@index)
  end

  def parse_line(obj)
    ##
    # obj 
    case obj
    when :current
      str = current_line.dup
    when Numeric
      str = get_line(obj).dup
    when String
      str = obj.dup  
    end

    return str, str.match(REGEXP_ASMB_COM)
  end

  def add_line(line)
    str, = incur_mode? ? sub_args(line) : line
    @data.push(str)
  end

  def add_lines(*lines)
    lines.each do |str| add_line(str) end
  end

  def parse_lines
    while(@index < line_count)
      str, match = parse_line(:current)
      #puts match[2] 
      @index += 1  

      if match
        # Command indentation has been removed since V1.5
        #nindent, comstr = match[1].to_i, match[2]
        comstr, = match[1]
        #puts comstr 
        command = execute_command(0, comstr)
        #sleep 0.1

        next if command        
      end

      add_line(str)

    end

    result
  end

  def result
    @data
  end

  def kind_of_command?(index=@index, lines=@lines)
    lines[index].match(REGEXP_ASMB_COM)
  end

  def command_line?(rgx, index=@index, lines=@lines)
    mtch = kind_of_command?(index, lines)
    return nil unless mtch
    return mtch[1].match(rgx)
  end

  # // Assembler Commands
  def execute_command(indent, str)
    @last_params = nil
    @last_indent = indent
    @@commands.each do |(symbol, regexp, asm_name, function)|
      @last_params = str.match(regexp)
      return instance_exec(&function) if @last_params
    end
    return false
  end

  def settings
    {
      definitions: @definitions,
      parent_source: @source,
      parent: self,
      indent: @indent,
      switches: @switches,
      records: @records,
      macros: @macros,
      index: @index
    }  
  end

  def get_define(str)
    @definitions[str]
  end

  def sub_arg(str)
    estr = str.clone

    @definitions.each_pair { |key, value| 
      if value.is_a?(DefFunc)
        rgx = /#{key}\(\s*(\w+(?:\s*,\s*\w+)*)\s*\)/
        next unless str =~ rgx
        estr = estr.gsub(rgx) {
          args = $1.split(/\s*,\s*/)
          rstr = value.value.clone
          args.each_with_index { |s, i|
            rstr.gsub!(value.params[i], args[i])
          }
          rstr
        }
        estr = sub_arg(estr)
      else
        estr = estr.gsub(key, value.to_s) 
      end  
    }
    estr
  end

  def sub_args(*strs)
    strs.collect(&method(:sub_arg))
  end

  # As of V1.5 and above, incur mode is always enabled.
  def incur_mode?
    #!!@switches["INCUR"]
    true 
  end

  def setup_imported 
    rgx = /\(\$imported\|\|\=\{\}\)\['(.+)'\]=(\S+)/i
    imports = @data.select do |s| s =~ rgx end
    @data.delete_if do |s| s =~ rgx end
    matches = imports.collect do |s| s.match(rgx) end.compact 
    length  = matches.max_by do |mtd| mtd[1].length end[1].length + 2
    str = matches.collect do |mtd| 
      %Q(%-0#{length}s => #{mtd[2]}) % "'#{mtd[1]}'" 
    end.sort#.join("\n")
    str.collect! do |s| s.indent(2) end
    str = str.join(",\n")
    fstr = %Q(($imported||={}).merge!(\n#{str}\n)).split(/[\r\n]/)
    add_lines *fstr
  end    

  def build
    @data.collect do |str| str.indent(@indent) end
  end

  def assemble
    build.join "\n"
  end

  # // Trim the @branch array to fit the current indent level
  def collapse_branch
    @branch.replace(@branch[0, @skj_indent])
  end

end
