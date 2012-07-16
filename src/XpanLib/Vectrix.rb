# // 05/07/2012
# // 06/07/2012
#-apndmacro _imported_
#-inject gen_scr_imported 'MACL::Vectrix', '0x08000'
#-end:
#-inject gen_class_header 'MACL::Vectrix'
module MACL
  class Vectrix
    module Constants
      # // Commands
      COMMAND_NULL       = 0
      COMMAND_DRAW_PIXEL = 1
      COMMAND_DRAW_LINE  = 2
      COMMAND_DRAW_BOX   = 3
      # // Data Types
      DATA_TYPE_SYM = {
        #'(?:rgb|color):\((\d+[%]?(?:\s*\d+[%]?\s*){2,3})\)',
        :color   => '(?:rgb|color)\(\d+%?\s+\d+%?\s+\d+%?(?:\s+\d+%?)?\)',
        :pos     => '(?:pos|point)\(\d+%\s+\d+%\)',
        :rect    => '(?:rect|box)\(\d+%\s+\d+%\s+\d+%\s+\d+%\)',
        :vector4 => '(?:v4|vector4)\(\d+%\s+\d+%\s+\d+%\s+\d+%\)',
        :int     => '(?:int|integer)\(\d+\)',
      }
      DATA_TYPE = DATA_TYPE_SYM.invert
    end
    module Parser
      REGEXP_TYPE    = /(?<name>\S+)\((?<parameters>.*)\)/
      REGEXP_COLOR   = /(?<red>\d+%?)\s+(?<green>\d+%?)\s+(?<blue>\d+%?)(?:\s+(?<alpha>\d+%?))?/
      REGEXP_POS     = /(?<x>\d+%)\s+(?<y>\d+%)/
      REGEXP_RECT    = /(?<x>\d+(?:%))\s+(?<y>\d+(?:%))\s+(?<width>\d+(?:%))\s+(?<height>\d+(?:%))/
      REGEXP_VECTOR4 = /(?<x1>\d+(?:%))\s+(?<y1>\d+(?:%))\s+(?<x2>\d+(?:%))\s+(?<y2>\d+(?:%))/
      REGEXP_INT     = /(?<value>\d+)/
      def self.str2ratem str,multiplier=1
        str = str.to_s unless str.is_a? String
        if str.end_with? ?%
          str.gsub('%','').to_i * multiplier
        else
          str.to_i
        end
      end
      TYPES = {
        ['rgb','color','rgba'] => proc do |s| 
          mt = s.match REGEXP_COLOR
          mt ? [:red,:green,:blue,:alpha].collect do |sym| str2ratem(mt[sym]||'255',2.55) end : [0,0,0,0]
        end,
        ['pos','point'] => proc do |s|
          mt = s.match REGEXP_POS
          mt ? [str2ratem(mt[:x]),str2ratem(mt[:y])] : [0.0,0.0]
        end,
        ['rect','box'] => proc do |s|
          mt = s.match REGEXP_RECT
          mt ? [mt[:x].to_i/100.0,mt[:y].to_i/100.0,mt[:width].to_i/100.0,mt[:height].to_i/100.0] : [0,0,0,0]
        end,
        ['v4','vector4'] => proc do |s|
          mt = s.match REGEXP_VECTOR4
          mt ? [mt[:x1].to_i/100.0,mt[:y1].to_i/100.0,mt[:x2].to_i/100.0,mt[:y2].to_i/100.0] : [0,0,0,0]
        end,
        ['int','integer'] => proc do |s|
          mt = s.match REGEXP_INT
          mt ? [mt[:value].to_i] : [0]
        end
      }
      TYPES.enum2keys!
      def self.parse_str str
        mt = str.match REGEXP_TYPE
        #p str,mt
        return nil unless mt
        name,parameters = mt[:name].downcase, mt[:parameters]
        dt = DataType.new name,TYPES[name].call(parameters)
        dt
      end
    end
    include Constants
    DataType = Struct.new :type, :params
    class DataType
      def as_type
        case type
        when 'pos','point'          ; Point.new *params
        when 'rect', 'box'          ; Surface.new *params
        when 'color', 'rgb', 'rgba' ; Color.new *params
        when 'v4', 'vector4'        ; Vector4.new *params
        when 'int', 'integer'       ; params[0]
        else 
          nil
        end
      end
    end
    @@blaz = MACL::Blaz.new
    # // draw_pixel: pos(0% 0%), color(255 255 255 255)
    # // draw_line: pos(0% 0%), pos(0% 0%), color(255 255 255 255), int(1)
    # // draw_box: rect(0% 0% 0% 0%), color(255 255 255 255)
    dtsym = DATA_TYPE_SYM
    draw_line  = /draw[_ ]?line:\s*(?<pos1>#{dtsym[:pos]})\s*,\s*(?<pos2>#{dtsym[:pos]})\s*,\s*(?<color>#{dtsym[:color]})(?:\s*,\s*(?<weight>#{dtsym[:int]}))?/i
    draw_box   = /[_ ]?(?:box|rect):\s*(?<rect>(?:#{dtsym[:rect]}|#{dtsym[:vector4]}))\s*,\s*(?<color>#{dtsym[:color]})/i
    draw_pixel = /draw[_ ]?pixel:\s*(?<pos>#{dtsym[:pos]})\s*,\s*(?<color>#{dtsym[:color]})/i
    
    @@blaz.add_command :draw_pixel, draw_pixel do |params|
      [COMMAND_DRAW_PIXEL,[Parser.parse_str(params[:pos]),Parser.parse_str(params[:color])]]
    end

    @@blaz.add_command :draw_line, draw_line do |params|
      [COMMAND_DRAW_LINE,
        [Parser.parse_str(params[:pos1]),Parser.parse_str(params[:pos2]),
         Parser.parse_str(params[:color]),Parser.parse_str(params[:weight]||'int(1)')]
      ]
    end

    @@blaz.add_command :draw_box, draw_box do |params|
      [COMMAND_DRAW_BOX,[Parser.parse_str(params[:rect]),Parser.parse_str(params[:color])]]
    end
    def self.str2stack str
      commands = str.split(/[\n;]/)
      #puts commands
      commands.collect do |s| 
        next if s.gsub(' ', '').start_with? ?#
        #break if s =~ /__END__/
        r = nil
        @@blaz.match_command s do |sym,mtch,func,params|
          r = func.call(mtch)
        end 
        r
      end.compact
    end
    def self.from_str str
      new str2stack(str)
    end
    attr_accessor :stack
    def initialize stack=[]
      @stack = stack
    end
    def to_bitmap width,height=nil
      bmp = width.is_a?(Bitmap) ? width : Bitmap.new(width,height)
      for ar in @stack
        process_command bmp, ar
      end
      bmp
    end
    def process_command bmp,array
      command,params = array
      params.map! &:as_type
      case command
      when COMMAND_NULL
        # // Do nothing! :3
      when COMMAND_DRAW_PIXEL
        point, color = params
        point.x *= bmp.width
        point.y *= bmp.height
        bmp.set_pixel point.x,point.y,color
      when COMMAND_DRAW_LINE
        point1,point2,color,weight = params
        point1.x *= bmp.width
        point1.y *= bmp.height
        point2.x *= bmp.width
        point2.y *= bmp.height
        bmp.draw_line point1,point2,color,weight.max(1)
      when COMMAND_DRAW_BOX 
        rect,color = params
        rect.x      *= bmp.width
        rect.width  *= bmp.width
        rect.y      *= bmp.height
        rect.height *= bmp.height
        bmp.fill_rect rect.to_rect,color
      end
    end
  end
end
#-inject gen_class_header 'Color'
class Color
  def to_vectrix
    "color(#{to_a.map(&:to_i).join(' ')})"
  end
end
#-inject gen_script_footer