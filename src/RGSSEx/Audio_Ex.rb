#-inject gen_module_header 'Audio'
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
#-skip:
__END__
#-end:
#-recmacro AudioObj
#-switch INCUR:ON
#-inject gen_class_header 'RPG::__CLASSNAME'
class RPG::__CLASSNAME
  include MACL::Mixin::AudioVolume
  def audio_sym
    __SYMNAME
  end
  def audio_path
    'Audio/__CLASSNAME/%s'
  end
#-ifdef __BGMS
  def play pos=0
    if @name.empty?
      Audio.__BSNAME_stop
      @@last = RPG::BGM.new
    else
      Audio.__BSNAME_play(audio_path % @name, self.volume, @pitch, pos) rescue nil
      @@last = self.clone
    end
  end
#-end:
#-ifdef __SEME
  def play
    if @name.empty?
      Audio.__BSNAME_stop
      @@last = RPG::BGM.new
    else
      Audio.__BSNAME_play(audio_path % @name, self.volume, @pitch) rescue nil
      @@last = self.clone
    end
  end
#-end:
end
#-switch INCUR:OFF
#-stopmacro AudioObj
#-define __BGMS
#-define __CLASSNAME#=BGM
#-define __BSNAME#=bgm
#-define __SYMNAME#=:__BSNAME
#-replay AudioObj
#-define __BGMS
#-define __CLASSNAME#=BGS
#-define __BSNAME#=bgs
#-define __SYMNAME#=:__BSNAME
#-replay AudioObj
#-undefine __BGMS
#-define __SEME
#-define __CLASSNAME#=ME
#-define __BSNAME#=me
#-define __SYMNAME#=:__BSNAME
#-replay AudioObj
#-define __CLASSNAME#=SE
#-define __BSNAME#=se
#-define __SYMNAME#=:__BSNAME
#-replay AudioObj
#-undefine __SEME
#-undefine __BGMS
#-undefine __SYMNAME
#-undefine __CLASSNAME
#-undefine __BSNAME
