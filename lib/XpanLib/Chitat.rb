# ╒╕ ■                                                         MACL::Chitat ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  class Chitat
    class Stack < Array
      attr_reader :match_data
      def initialize match_data,*args,&block
        @match_data = match_data
        super *args,&block
      end
      alias arra_inspect inspect
      def inspect
        "<#{self.class.name} %s: %s>" % [@match_data.to_s, arra_inspect]
      end
    end
    class Tag
      attr_reader :sym,:params
      def initialize sym,match_data
        @sym,@params = sym,match_data.to_a
      end
      def param i
        @params[i]
      end
    end
    attr_accessor :open_rgx,:close_rgx
    attr_reader :tags
    def initialize open_tag=nil,close_tag=nil
      @tags = []
      if open_tag.is_a?(String) and close_tag.is_a?(String)
        open_tag = mk_open_rgx open_tag
        close_tag = mk_close_rgx close_tag
      end
      if !close_tag and open_tag
        mk_and_set_rgx open_tag
      else
        @open_rgx,@close_rgx = open_tag,close_tag
      end
      yield self if block_given?
    end
    # //
    def set_tag sym, regexp
      @tags << {sym: sym, regexp: regexp}
    end
    def mk_tag str
      @tags.each do |hsh|
        sym,regexp = hsh.get_values :sym,:regexp
        mtch = str.match regexp
        return Tag.new sym, mtch if mtch
      end
      return nil
    end
    def mk_open_rgx str
      /<#{str}>/i
    end
    def mk_close_rgx str
      /<\/#{str}>/i
    end
    def mk_and_set_rgx str
      @open_rgx,@close_rgx = mk_open_rgx(str),mk_close_rgx(str)
      self
    end
    def parse_str str
      raise "Regexp has not been set!" unless @open_rgx and @close_rgx
      lines  = str.split(/[\r\n]+/i)
      i,line,result,arra = 0, nil,[],[]
      while i < lines.size
        line = lines[i]
        if mtch = line.match(@open_rgx)
          while true
            i += 1
            line = lines[i]
            break if line =~ @close_rgx
            result << line
            raise "End of note reached!" if i > lines.size
          end
          arra.push Stack.new(mtch,result)
          result = []
        end
        i += 1
      end
      arra
    end
    def parse_str4tags str
      arra = parse_str str
      arra.each do |a| a.collect! { |s| mk_tag s }; a.compact! end
      arra.reject! do |a| a and a.empty? end
      arra
    end
  end
end