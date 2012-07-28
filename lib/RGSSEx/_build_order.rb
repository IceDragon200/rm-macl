#// RGGSEx
# ╒╕ ■                                                          RPG::Metric ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module RPG
  module Metric
    COLOR_CAP    = 255
    COLOR_BASE   = 0
    TONE_CAP     = 255
    TONE_BASE    = 0
    OPACITY_CAP  = 255
    OPACITY_BASE = 0
  end  
end
# ╒╕ ■                                                             Graphics ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class << Graphics
  def rect
    Rect.new(0,0,width,height)
  end unless method_defined? :rect 
  def frames_to_sec frames 
    frames / frame_rate.to_f
  end    
  alias frm2sec frames_to_sec
  def sec_to_frames sec
    sec * frame_rate
  end
  alias sec2frm sec_to_frames
end
# ╒╕ ■                                                                Audio ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module Audio
  @@vol_rate = {
    default: 1.0,
    bgm: 1.0,
    bgs: 1.0,
    me: 1.0,
    se: 1.0
  }
  def self.vol_rate sym
    @@vol_rate[sym]
  end
  def self.vol_rate_set sym,value
    @@vol_rate[sym] = value
  end
end
# ╒╕ ■                                             MACL::Mixin::AudioVolume ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  module Mixin
    module AudioVolume
      def audio_sym
        :default
      end
      def audio_path
        'Audio/%s'
      end
      def vol_rate
        Audio.vol_rate audio_sym
      end
      def volume_abs
        @volume
      end
      def volume
        volume_abs * vol_rate
      end
    end
  end
end
# ╒╕ ♥                                                             RPG::BGM ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class RPG::BGM
  include MACL::Mixin::AudioVolume
  def audio_sym
    :bgm
  end
  def audio_path
    'Audio/BGM/%s'
  end
  def play pos=0
    if @name.empty?
      Audio.bgm_stop
      @@last = RPG::BGM.new
    else
      Audio.bgm_play(audio_path % @name, self.volume, @pitch, pos) rescue nil
      @@last = self.clone
    end
  end
end
# ╒╕ ♥                                                             RPG::BGS ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class RPG::BGS
  include MACL::Mixin::AudioVolume
  def audio_sym
    :bgs
  end
  def audio_path
    'Audio/BGS/%s'
  end
  def play pos=0
    if @name.empty?
      Audio.bgs_stop
      @@last = RPG::BGM.new
    else
      Audio.bgs_play(audio_path % @name, self.volume, @pitch, pos) rescue nil
      @@last = self.clone
    end
  end
end
# ╒╕ ♥                                                              RPG::ME ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class RPG::ME
  include MACL::Mixin::AudioVolume
  def audio_sym
    :me
  end
  def audio_path
    'Audio/ME/%s'
  end
  def play
    if @name.empty?
      Audio.me_stop
      @@last = RPG::BGM.new
    else
      Audio.me_play(audio_path % @name, self.volume, @pitch) rescue nil
      @@last = self.clone
    end
  end
end
# ╒╕ ♥                                                              RPG::SE ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class RPG::SE
  include MACL::Mixin::AudioVolume
  def audio_sym
    :se
  end
  def audio_path
    'Audio/SE/%s'
  end
  def play
    if @name.empty?
      Audio.se_stop
      @@last = RPG::BGM.new
    else
      Audio.se_play(audio_path % @name, self.volume, @pitch) rescue nil
      @@last = self.clone
    end
  end
end
# ╒╕ ♥                                                                Color ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Color
  def hash
    [self.red,self.green,self.blue,self.alpha].hash
  end
  def rgb_sym
    return :red, :green, :blue
  end
  def to_a
    return self.red, self.green, self.blue, self.alpha
  end
  def to_a_na
    return self.red, self.green, self.blue
  end
  alias to_a_ng to_a_na
  def to_hex
    to_a_na.collect{|i|"%02x"%i}.join ''
  end
  def to_flash
    to_hex.hex
  end
  def to_color
    Color.new *to_a
  end
  def to_tone
    Tone.new *to_a
  end
  def to_hash
    {red: red, green: green, blue: blue, alpha: alpha}
  end
end
# ╒╕ ♥                                                                 Tone ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tone
  def rgb_sym
    return :red, :green, :blue
  end
  def to_a
    return self.red, self.green, self.blue, self.gray
  end
  def to_a_ng
    return self.red, self.green, self.blue
  end
  alias to_a_na to_a_ng
  def to_hex
    to_a_na.collect{|i|"%02x"%i}.join ''
  end
  def to_flash
    to_hex.hex
  end
  def to_color
    Color.new *to_a
  end
  def to_tone
    Tone.new *to_a
  end
  def to_hash
    {red: red, green: green, blue: blue, grey: grey}
  end
end
# ╒╕ ♥                                                                 Font ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Font
  def to_hsh
    {
      :color       => font.color.to_color,
      #:shadow_color => font.shadow_color.to_color, YGG1x*
      :out_color    => font.out_color.to_color,
      :name         => self.name.to_a.clone,
      :size         => self.size.to_i,
      :bold         => self.bold.to_bool,
      :italic       => self.italic.to_bool,
      :shadow       => self.shadow.to_bool,
      :outline      => self.outline.to_bool
    }
  end  
  def marshal_dump
    to_hsh
  end
  def marshal_load hsh
    hsh.each_pair do |key,value|
      send(key.to_s+?=,value)
    end
  end
end
# ╒╕ ♥                                                                 Rect ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Rect
  def / n
    self.class.new(self.x/n,self.y/n,self.width/n,self.height/n)
  end
  def * n
    self.class.new(self.x*n,self.y*n,self.width*n,self.height*n)
  end
  def to_a
    return self.x, self.y, self.width, self.height
  end
  def to_va
    return self.x, self.y, self.x+self.width, self.y+self.height
  end
  def to_rect
    Rect.new *to_a
  end
  def area
    self.width*self.height
  end
  def empty?
    self.width == 0 and self.height == 0
  end
end
# ╒╕ ♥                                                                Table ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Table
  include MACL::Mixin::TableExpansion  
end
# ╒╕ ♥                                                               Bitmap ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Bitmap
  def fill sx,sy,color=Color.new(255,255,255,255)
    base_color = get_pixel sx,sy
    nodes = []
    nodes << [sx,sy]
    table = Table.new width,height 
    nx = ny = x = y =0
    while nodes.size > 0
      x,y = nodes.shift
      next unless x and y
      next if table[x,y] > 0
      set_pixel(x,y,color) 
      table[x,y] = 1
      for iy in -1..1
        for ix in -1..1
          nx,ny = x+ix,y+iy
          next if table[nx,ny].to_i > 0
          next unless get_pixel(nx,ny) == base_color
          nodes << [nx,ny] 
        end
      end
    end
  end
  def recolor! f_color,t_color=nil 
    if f_color.is_a? Color and t_color.is_a? Color 
      hsh = { f_color => t_color }
    elsif f_color.is_a? Array && t_color 
      arra = t_color.is_a? Enumerable ? t_color : [t_color]*f_color.size 
      hsh = {};f_color.each_with_index{|c,i|hsh[c]=arra[i]}
    else  
      hsh = f_color
    end  
    x,y,color = nil,nil,nil
    iterate do |x,y,color| 
      set_pixel(x,y,hsh[color]||color) 
    end
  end 
  def recolor *args,&block
    dup.recolor! *args,&block
  end
  def iterate_map 
    iterate { |x,y,color| set_pixel(x,y,yield(x,y,color)) }
  end
  def legacy_recolor color1,color2
    for y in 0...height
      for x in 0...width
        set_pixel x,y,color2 if get_pixel(x,y) == color1
      end
    end
  end 
  def palletize 
    pallete = Set.new
    iterate do |x,y,color| pallete << color.to_a end
    pallete.to_a.sort.collect do |a| Color.new *a end
  end  
  #def iterate
  #  for y in 0...height
  #    for x in 0...width
  #      yield x, y, get_pixel(x,y) 
  #    end
  #  end   
  #end 
  def draw_line point1,point2,color,weight=1
    weight = weight.max(1).to_i
    x1,y1 = point1.to_a.map! &:to_i
    x2,y2 = point2.to_a.map! &:to_i
    # Bresenham's line algorithm
    a = (y2 - y1).abs
    b = (x2 - x1).abs
    s = (a > b)
    dx = (x2 < x1) ? -1 : 1
    dy = (y2 < y1) ? -1 : 1
    if s
      c = a
      a = b
      b = c
    end
    df1 = ((b - a) << 1)
    df2 = -(a << 1)
    d = b - (a << 1)
    set_pixel_weighted(x1, y1, color, weight) 
    if(s)
      while y1 != y2
        y1 += dy
        if d < 0
          x1 += dx
          d += df1
        else
          d += df2
        end
        set_pixel_weighted(x1, y1, color, weight) 
      end
    else
      while x1 != x2
        x1 += dx
        if d < 0
          y1 += dy
          d += df1
        else
          d += df2
        end
        set_pixel_weighted(x1, y1, color, weight) 
      end
    end 
  end
  def set_pixel_weighted x,y,color,weight=1
    even = ((weight % 2) == 0) ? 1 : 0
    half = weight / 2
    for px in (x-half)..(x+half-even)
      for py in (y-half)..(y+half-even)
        self.set_pixel(px, py, color) 
      end
    end
  end
end
# ╒╕ ♥                                                               Sprite ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Sprite
  include MACL::Mixin::Surface
  def move x,y
    self.x,self.y=x,y
  end
  def to_rect
    Rect.new x,y,width,height
  end
  def to_cube
    Cube.new x,y,z,width,height,0
  end
end