# // RCG
require_relative 'Mimi'
module RCG
  include Mimi
  def self.write_bin struct
    # // Header
    w = num2hex_s struct.width
    h = num2hex_s struct.height
    v = num2hex_s struct.version
    b = num2hex_s struct.bit_depth
    # // Color Table
    cols = struct.colors.collect do |c| 
      c.collect do |i| num2hex_s i end
    end
    struct
  end
  class FileStruct
    attr_accessor :colors
    attr_accessor :data
    def initialize v,b,w,h
      @header = {version: v,bit_depth: b,width: w,height: h}
      @colors = Array.new 1 do [0,0,0,0] end
      @data   = Array.new width*height,0
      @meta   = {}
    end
    attr_reader :meta
    def width
      @header[:width]
    end
    def height
      @header[:height]
    end
    def version
      @header[:version]
    end
    def bit_depth
      @header[:bit_depth]
    end
    def refresh
      @colors.collect!{|c|c.collect{|i|i.to_i}}
      @data.replace @data[0...(width*height)]
      self
    end
  end
  class Reader
    RGX_HEADER = /\[(.*)\]/i
    def self.line offset=0
      return @lines[@rindex+offset]
    end
    def self.str2namevalue_a str
      mtch = str.match /(.*)\=(.*)/i
      return nil unless(mtch)
      return mtch[1], mtch[2]
    end
    def self.collect_until_header index
      result = []
      for i in index...@lines.size
        @rindex = i
        result << line
        break if line(1)=~RGX_HEADER
      end
      return result
    end
    def self.header?
      raise "Header does not exist" unless !!@rcg
      true
    end
    def self.read_rcgt string
      @lines   = string.split /[\r\n]+/i
      @rindex  = 0
      @rcg     = nil
      comments = []
      while @rindex < @lines.size
        case line.chomp
          when /\/\//i
            comments << line
            #@rindex += 1
          when /\[HEADER\]/i
            puts "Header Found"
            hsh = {}
            collect_until_header(@rindex).each do |tag|
              n=str2namevalue_a tag
              next unless n
              name,value = n
              hsh[name.downcase.to_sym] = value.to_s
            end
            b,v,w,h = hsh.get_values(:bit_depth,:version,:width,:height)
            @rcg = FileStruct.new(b.to_i,v.to_s,w.to_i,h.to_i)
          when /\[METADATA\]/i
            header?
            puts "MetaData Found"
            collect_until_header(@rindex).each do |tag|
              n = str2namevalue_a tag
              next unless n
              name,value = n
              @rcg.meta[name.upcase] = value
            end
          when /\[COLORTABLE\]/i
            header?
            puts "Color Table Found"
            collect_until_header(@rindex).each do |tag|
              n = str2namevalue_a tag
              next unless n
              name,value = n
              @rcg.colors[name.to_i] = value.split ?,
            end
          when /\[IMAGE\]/i
            header?
            puts "Image Data Found"
            dx = 0
            collect_until_header(@rindex).each do |tag|
              a = tag.split(?,).collect{|s|s.to_i}
              @rcg.data[dx...dx+a.size] = a
              dx += a.size
            end
        end
        @rindex += 1
      end
      @rcg.refresh
    end
  end
end
