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
  @vol_rate = {
    default: 1.0,
    bgm: 1.0,
    bgs: 1.0,
    me: 1.0,
    se: 1.0
  }
  def self.vol_rate sym
    @vol_rate[sym]
  end
end
module MACL::Mixin::AudioVolume
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
  def empty?
    self.width == 0 and self.height == 0
  end
end
# ╒╕ ♥                                                              Vector4 ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Vector4 < Rect
  def rwidth
    self.width - self.x
  end
  def rheight
    self.height - self.y
  end
  def vwidth
    self.width
  end
  def vheight
    self.height
  end
  def self.v4a_to_rect v4a
    return Rect.new v4a[0], v4a[1], v4a[2]-v4a[0], v4a[3]-v4a[1]
  end
end
# ╒╕ ♥                                                                Table ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Table
  include MACL::Mixin::TableExpansion  
end
warn 'Bitmap_Ex is already imported' if ($imported||={})['Bitmap_Ex']
($imported||={})['Bitmap_Ex']=0x10002
# ╒╕ ♥                                                               Bitmap ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Bitmap
  def fill sx,sy,color=Color.new(255,255,255,255)
    base_color = get_pixel sx,sy
    nodes = []
    nodes << [sx,sy]
    table = Table.new width,height 
    nx=ny=x=y=0
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
      yield if block_given? 
    end
  end
  def recolor f_color,t_color=nil 
    if f_color.is_a? Color and t_color.is_a? Color 
      hsh = { f_color => t_color }
    elsif f_color.is_a? Array && t_color 
      arra = t_color.is_a? Enumerable ? t_color : [t_color]*f_color.size 
      hsh = {};f_color.each_with_index{|c,i|hsh[c]=arra[i]}
    else  
      hsh = f_color
    end  
    x,y,color = nil,nil,nil
    iterate_do { |x,y,color| set_pixel(x,y,hsh[color]||color) }
  end 
  def iterate_map 
    iterate_do { |x,y,color| set_pixel(x,y,yield(x,y,color)) }
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
    iterate_do true do |x,y,color| pallete << color.to_a end
    pallete.to_a.sort.collect do |a|Color.new *a end
  end  
  def iterate_do return_only=false 
    x, y = nil, nil
    for y in 0...height
      for x in 0...width
        yield x,y,get_pixel(x,y) 
      end
    end   
  end 
  def draw_line point1,point2,color,weight
    x1,y1 = point1.to_a
    x2,y2 = point2.to_a
    dx = x2 - x1
    dy = y2 - y1
    sx = x1 < x2 ? 1 : -1
    sy = y1 < y2 ? 1 : -1
    err= (dx-dy).to_f
    e2 = 0
    loop do
      set_pixel_weighted x1,x2,color,weight 
      break if x1 == x2 and y1 == y2 
      e2 = 2*err
      if e2 > -dy 
        err = err - dy
        x1  = x1 + sx  
      end
      if e2 < dx 
        err = err + dx
        y1  = y1 + sy 
      end
    end  
  end
  def set_pixel_weighted x,y,color,weight=1
    weight.times do |i| set_pixel(x,y+i,color) end
  end
end
# ╒╕ ♥                                                               Sprite ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Sprite
  def to_rect
    Rect.new x,y,width,height
  end
  def to_cube
    Cube.new x,y,z,width,height,0
  end
end
# ╒╕ ♥                                                     RPG::Event::Page ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module RPG
  class Event
    class Page
      COMMENT_CODES = [108,408]
      def select_commands *codes
        @list.select do |c| codes.include?(c.code) end
      end
      def comments
        select_commands *COMMENT_CODES
      end
      def comments_a
        comments.map!(&:parameters).flatten!
      end
    end
  end
end
# ╒╕ ♥                                                          Game::Event ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Game_Event
  def comment_a
    @page.comment_a
  end
end
# ╒╕ ■                                                         SceneManager ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module SceneManager
  def self.recall
    goto(@scene.class)
  end
end
# ╒╕ ■                                                           MapManager ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MapManager
  @@maps = {}
  def self.load_map id
    get_map(id).deep_clone
  end 
  def self.get_map id
    unless @@maps.has_key? id
      @@maps[id] = load_data("Data/Map%03d.rvdata2" % id)
      @@maps[id].do_note_scan
    end
    @@maps[id]
  end
end
# ╒╕ ♥                                                            Game::Map ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Game_Map
  def pre_load_map
  end
  def post_load_map
  end
  # // Overwrite
  def setup map_id 
    @map_id = map_id
    pre_load_map
    @map = MapManager.load_map @map_id 
    post_load_map
    @tileset_id = @map.tileset_id
    @display_x = 0
    @display_y = 0
    referesh_vehicles
    setup_events
    setup_scroll
    setup_parallax
    setup_battleback
    @need_refresh = false
  end
end
# ╒╕ ♥                                                       Game::Switches ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Game_Switches
  def on? id 
    !!self[id]
  end
  def off? id
    !self[id]
  end
  def toggle id
    self[id] = !self[id]
  end
end