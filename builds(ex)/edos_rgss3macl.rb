=begin
 ──────────────────────────────────────────────────────────────────────────────
 RGSS3-MACL
 Version : 0x1000B
 Last Build: 13/07/2012 (MM/DD/YYYY) (0x1000A)
 Date Built: 13/07/2012 (MM/DD/YYYY) (0x1000B)
 ──────────────────────────────────────────────────────────────────────────────
 ■ Module
 ♥ Class
=end
# // Standard Library
# ╒╕ ♥                                                               Object ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Object
  def deep_clone
    Marshal.load Marshal.dump(self) 
  end
  def if_eql? obj,alt=nil
    return self.eql?(obj) ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_eql? 
  def if_neql? obj,alt=nil
    return (!self.eql?(obj)) ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_neql? 
  def if_nil? alt=nil
    return self.nil? ? (block_given? ? yield : alt) : self
  end unless method_defined? :if_nil?
  def to_bool
    !!self
  end unless method_defined? :to_bool
end
# ╒╕ ♥                                                               Module ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Module
  def memoize *syms
    syms.each do |sym|
      nm = 'pre_memoize_%s' % sym.to_s
      alias_method nm, sym
      module_eval %Q(
        def #{sym}(*args); @#{'memoize_%s' % sym.to_s}||=#{nm}(*args) end
      )
    end
  end unless method_defined? :memoize
  def memoize_as hash
    hash.each_pair do |sym,n|
      module_eval %Q(def #{sym}; @#{sym}||=#{n} end)
    end
  end unless method_defined? :memoize_as
end
# ╒╕ ♥                                                        Error_NoSkinj ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Error_NoSkinj < StandardError
  def message
    'Skinj is not installed!'
  end
end
# ╒╕ ■                                                               Kernel ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module Kernel
  def load_data filename 
    obj = nil
    File.open filename,"rb" do |f| obj = Marshal.load f  end
    obj
  end unless method_defined? :load_data
  def save_data obj,filename 
    File.open filename,"wb" do |f| Marshal.dump obj, f  end
  end unless method_defined? :save_data
  def load_data_cin filename 
    save_data yield,filename  unless FileTest.exist? filename 
    load_data filename 
  end unless method_defined? :load_data_cin
  def Boolean obj 
    !!obj
  end unless method_defined? :Boolean
  def skinj_eval hsh
    raise Error_NoSkinj.new unless ($imported||={})['Skinj']
    eval_string  = hsh[:eval_string]
    binding      = hsh[:binding]
    skinj_params = hsh[:skinj_params]
    result = Skinj.skinj_str str, *skinj_params
    return eval result,binding
  end unless method_defined? :skinj_eval 
end
# ╒╕ ♥                                                              Numeric ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Numeric
  def count n=1
    i = self
    loop do
      i = i + n
      yield i
    end
  end
  def negative?
    self < 0
  end
  def positive?
    self > 0
  end
  def min n
    n < self ? n : self
  end unless method_defined? :min
  def max n
    n > self ? n : self
  end unless method_defined? :max
  def clamp min,max
    self < min ? min : (self > max ? max : self)
  end unless method_defined? :clamp
  def unary
    self <=> 0
  end unless method_defined? :unary
  def unary_inv
    -pole
  end unless method_defined? :unary_inv
  # // ROMAN and to_roman by Zetu
  ROMAN = {
        1 => "I",    5 => "V",    10 => "X",
       50 => "L",  100 => "C",   500 => "D",
     1000 => "M", 5000 => "" , 10000 => ""
  }
  def to_roman
    value = self
    return '---' if value >= 4000
    base = ""
    for key in ROMAN.keys.sort.reverse
      a = value / key
      case a
      when 0; next
      when 1, 2, 3
        base += ROMAN[key]*a
      when 4
        base += ROMAN[key]
        base += ROMAN[key*5]
      when 5, 6, 7, 8
        base += ROMAN[key*5]
        base += ROMAN[key]*a-5
      when 9
        base += ROMAN[key*10]
        base += ROMAN[key]
      end
      value -= a * key
    end
    return base
  end unless method_defined? :to_roman
end
# ╒╕ ♥                                                               String ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class String
  def indent *args
    dup.indent! *args
  end
  def indent! n=0,s=" "
    self.replace s*n+self
  end
  def word_wrap chars=80
    char_count = 0
    arra = []
    result_str = ''
    self.scan(/(\S+)/i).each do |str|
      if char_count + str.size < str.chars
        char_count += str.size
        arra << str
      else
        result_str += arra.join(' ')+"\n"
        char_count,arra = 0,[]
      end
    end
  end
  def word_wrap! chars=80
    self.replace word_wrap(chars)
  end
  def character_wrap characters=459
    text = self
    return text if characters <= 0
    white_space = " "
    result,r = [],""
    text.split(' ').each do |word|
      (result << r;r = "") if r.size + word.size > characters
      r << word+white_space
    end
    result << r unless r.empty?
    result
  end
  def as_bool
    case self.upcase
      when *MACL::Parser::STRS_TRUE  ; return true
      when *MACL::Parser::STRS_FALSE ; return false
      else                           ; return nil
    end
  end
end
# ╒╕ ■                                                           Enumerable ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module Enumerable
  def pick
    self[rand(self.size)] 
  end unless method_defined? :pick 
  def reverse_index obj=nil
    if block_given? ; size.downto(0) do |i| return i if yield(self[i]) end
    else            ; size.downto(0) do |i| return i if self[i] == obj end
    end
    -1
  end
  def invoke meth_sym,*args,&block 
    each { |o| o.send(meth_sym,*args,&block) };self
  end
  def invoke_collect meth_sym,*args,&block
    collect { |o| o.send(meth_sym,*args,&block) }
  end
end
# ╒╕ ♥                                                                Array ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Array
  def offset obj
    res = self.shift
    self.push obj
    res
  end
  def pick!
    self.delete n=pick;n
  end unless method_defined? :pick! 
  def pad *args,&block
    dup.pad! *args,&block
  end  
  def pad! n,obj=nil
    self.replace(self[0,n]) if self.size > n
    self.push(block_given? ? yield : obj) while self.size < n
    self
  end 
  def uniq_arrays *args,&block
    dup.uniq_arrays *args,&block
  end
  def uniq_arrays! groups 
    all_objs,uniquesets = self, []
    set, lastset, i, group = nil, nil, nil, nil
    while(all_objs.size > 0)
      set = all_objs.clone
      for i in 0...groups.size
        group = groups[i]
        lastset = set
        set = set & group
        set = lastset if(set.empty?())
      end
      uniquesets << set
      all_objs -= set
    end
    self.replace(uniquesets)
    self
  end
  def rotate n=1
    dup.rotate! n 
  end unless method_defined? :rotate
  def rotate! n=1
    return self if empty?
    n %= size
    concat(slice!(0,n))
  end unless method_defined? :rotate!
  def remove_this obj,n=1
    i = 0
    n.times { (i = self.index(obj)) ? self.delete_at(i) : break }; self
  end
end
# ╒╕ ♥                                                                 Hash ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Hash
  def replace_key *args,&block
    dup.replace_key! *args,&block
  end
  def replace_key! hash={}
    k,v = [nil]*2
    if block_given?
      keyz = self.keys
      keyz.each do |k| v = yield k ; self[v] = self.delete k end
    else
      hash.each_pair do |k,v| self[v] = self.delete k end
    end
    self
  end
  def remap &block
    dup.remap! &block
  end
  def remap!
    key,value = [nil]*2
    hsh = self.each_pair.to_a; self.clear
    hsh.each do |(key,value)|
      key,value = yield key,value; self[key] = value
    end
    self
  end
  def get_values *keys
    keys.collect{|a|self[a]}
  end
  def enum2keys
    dup.enum2keys!
  end
  def enum2keys!
    r,key,value = [nil]*3
    replace(inject(Hash.new) do |r,(key,value)|
      case key
      when Enumerable ; key.each { |i| r[i] = value }
      else            ; r[key] = value
      end
      r
    end)
    self
  end
end
# ╒╕ ♥                                                            MatchData ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class MatchData
  def to_hash
    hsh = {}
    return hsh if captures.empty?
    if names.empty? ; (0..10).each do |i| hsh[i] = self[i] end
    else            ; names.each do |s| hsh[s] = self[s] end
    end
    hsh
  end unless method_defined? :to_hash
end
# ╒╕ ■                                                                 MACL ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  @@initialized = []
  @@inits = []
  def self.init
    constants.collect(&method(:const_get)).each(&method(:invoke_init))
    run_init # // Extended scripts
  end
  def self.invoke_init nodule
    nodule.init if nodule.respond_to? :init
  end
  def self.add_init sym,func
    @@inits << [sym,func]
  end
  def self.run_init
    @@inits.each do |(sym,func)|
      p "%s was already initialized" if @@initialized.include? sym
      begin
        func.call 
      rescue Exception => ex
        p 'MACL: %s failed to load:' % sym.to_s
        p ex
        next
      end
      @@initialized << sym
    end
  end
  module Mixin
  end
end
module MACL
  module Constants
    ANCHOR = {
    # // Standard
      null: 0,
      center: 5,
      horizontal: 11, # // Horizontal
      horz: 11,
      horz0: 12, # // Horizontal Top
      horz1: 13, # // Horizontal Mid
      horz2: 14, # // Horizontal Bottom
      # // Vertical
      vertical: 15, # // Vertical
      vert: 15,
      vert0: 16, # // Vertical Top
      vert1: 17, # // Vertical Mid
      vert2: 18, # // Vertical Bottom
      # // Based on NUMPAD
      left: 4,
      right: 6,
      top: 8,
      up: 8,
      bottom: 2,
      down: 2,
      top_left: 7,
      top_right: 9,
      bottom_left: 1,
      bottom_right: 3
    }
  end
end
# ╒╕ ■                                                          MACL::Mixin ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  module Mixin
# ╒╕ ■                                                    BaseItem_NoteScan ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
    module BaseItem_NoteScan
      private
      def pre_note_scan
        @note.each_line { |line| parse_note_line(line, :pre) }
      end
      def note_scan
        @note.each_line { |line| parse_note_line(line, :mid) }
      end
      def post_note_scan
        @note.each_line { |line| parse_note_line(line, :post) }
      end
      def parse_note_line line, section
      end
      public
      def do_note_scan
        pre_note_scan
        note_scan
        post_note_scan
      end
    end
    module TableExpansion 
    end
    module Surface
    end
  end
end
# // Xpansion Library
# ╒╕ ■                                               MACL::Mixin::Archijust ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  module Mixin
    module Archijust
      def define_as hash
        hash.each_pair do |k,v| define_method k do v end end
      end
      # // Update on change
      def define_uoc *syms
        syms.each do |sym|
          alias_method "set_#{sym}", "#{sym}="
          module_eval %Q(def #{sym}= n; set_#{sym} n if @#{sym} != n end)
        end
      end
      def define_clamp_writer hash
        hash.each_pair do |k,v|
          module_eval %Q(def #{k}= n; @#{k} = n.clamp(#{v[0]},#{v[1]}) end)
        end
      end
      # // stuff! and stuff
      def define_exfunc sym,&func
        str = sym.to_s+'!'
        define_method str,&func
        define_method sym do |*args,&block| dup.__send__(str,*args,&block) end
      end
    end
  end
end
# ╒╕ ■                                          MACL::Mixin::TableExpansion ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  module Mixin
    module TableExpansion
      def area
        xsize*ysize
      end
      def volume
        xsize*ysize*zsize
      end
      def iterate
        x,y,z=[0]*3
        if zsize > 1
          for z in 0...zsize
            for y in 0...ysize
              for x in 0...xsize
                yield self[x,y,z], x, y, z
              end
            end
          end
        elsif ysize > 1
          for y in 0...ysize
            for x in 0...xsize
              yield self[x,y], x, y
            end
          end  
        else
          for x in 0...xsize
            yield self[x], x
          end  
        end
        Graphics.frame_reset
        self
      end
      def iterate_map
        i=0;xyz=[0,0,0]
        iterate do |i,*xyz|
          self[*xyz] = yield i, *xyz
        end
        self
      end
      def replace table
        i=0;xyz=[0,0,0]
        resize table.xsize, table.ysize, table.zsize
        iterate do |i,*xyz|
          self[*xyz] = table[*xyz]
        end
        self
      end
      def clear
        resize 1
        self
      end
      def nudge nx,ny,nz 
        tabclone = self.dup
        xs,ys,zs = tabclone.xsize, tabclone.ysize,tabclone.zsize
        i,x,y,z=[0]*4
        if zs > 0
          tabclone.iterate do |i,x,y,z| self[(x+nx)%xs,(y+ny)%ys,(z+nz)%zs] = i end
        elsif ys > 0  
          tabclone.iterate do |i,x,y| self[(x+nx)%xs,(y+ny)%ys] = i end
        else  
          tabclone.iterate do |i,x| self[(x+nx)%xs] = i end
        end  
        self
      end  
      def oor? x,y=0,z=0
        return true if x < 0 || y < 0 || z < 0
        return true if xsize <= x
        return true if ysize <= y if ysize > 0
        return true if zsize <= z if zsize > 0
        return false
      end
      def to_a
        tabe = begin
          if @zsize > 1
            Array.new @xsize do 
              Array.new @ysize do 
                Array.new @zsize, 0 
              end 
            end
          elsif @ysize > 1
            Array.new @xsize do 
              Array.new @ysize, 0
            end
          else
            Array.new @xsize, 0
          end
        end  
        x,y,z,n,xyz = [nil]*5
        iterate do |n,*xyz|
          x,y,z = *xyz
          if xyz.size == 3
            tabe[x][y][z] = n
          elsif xyz.size == 2
            tabe[x][y] = n
          else
            tabe[x] = n  
          end
        end
        tabe
      end
    end
  end
end
# ╒╕ ♥                                                                Point ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Point
  def self.convert2point array
    Point.new(*array[0..1])
  end
  attr_accessor :x, :y
  class << self
    alias :[] :new
  end
  def initialize x=0,y=0
    @x,@y = x,y
  end
  def set x=0,y=0
    @x,@y = x||@x,y||@y
    self
  end
  alias old_to_s to_s
  def to_s
    return "<#{self.class.name}: %s, %s>" % [self.x,self.y]
  end
  def to_a
    return @x,@y
  end
  def to_hash
    return {x: @x, y: @y}
  end
  def hash
    return [@x,@y].hash
  end
  def unaries
    return [@x <=> 0, @y <=> 0]
  end
end
# ╒╕ ♥                                                           MACL::Cube ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  class Cube
    SYM_ARGS = [:x,:y,:z,:width,:height,:length]
    attr_accessor *SYM_ARGS
    def initialize *args
      set *args
    end
    def hash
      [@x,@y,@z,@width,@height,@length].hash
    end
    def translate x,y,z
      @x, @y, @z = x, y, z
    end
    def set x=0,y=0,z=0,w=0,h=0,l=0
      @x, @y, @z = x, y, z
      @width, @height, @length = w, h, l
    end
    def xset x=nil,y=nil,z=nil,w=nil,h=nil,l=nil
      x,y,z,w,h,l = *x if x.is_a? Array
      x,y,z,w,h,l = x.get_values *SYM_ARGS  if x.is_a? Hash
      set x||@x,y||@y,z||@z,w||@width,h||@height,l||@length
      self
    end
    # // pass symbols and recive values
    def xto_a *args
      return (args&SYM_ARGS).collect{ |sym| self.send sym }
    end
    def to_a
      return @x, @y, @z, @width, @height, @length
    end
    def to_rect
      Rect.new @x, @y, @width, @height
    end
    def to_hash
      return {x: @x,y: @y,z: @z,width: @width,height: @height,length: @length}
    end
    def to_s
      return "<#{self.class.name}: x%s y%s z%s w%s h%s l%s>" % to_a
    end
    def empty
      set
      self
    end
    def area1
      @width*@height
    end
    def area2
      @width*@length
    end
    def area3
      @height*@length
    end
    def volume
      @width*@height*@length
    end
  end
end
Cube = MACL::Cube
#// RGGSEx
class Game ; end
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
class Game::Map
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
class Game::Switches
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
MACL.init;
($imported||={}).merge!(
  'Archijust'      => 0x10001,
  'Core-Audio'     => 0x10001,
  'Core-Bitmap'    => 0x10003,
  'Core-Color'     => 0x10002,
  'Core-Font'      => 0x10001,
  'Core-Graphics'  => 0x10001,
  'Core-Rect'      => 0x10001,
  'Core-Sprite'    => 0x10001,
  'Core-Table'     => 0x10001,
  'Core-Tone'      => 0x10001,
  'MACL::Cube'     => 0x10002,
  'Point'          => 0x10002,
  'RGSS3-MACL'     => 0x1000B,
  'TableExpansion' => 0x10001
)
# ┌┬────────────────────────────────────────────────────────────────────────┬┐
# ╘╛ ● End of File ●                                                        ╘╛