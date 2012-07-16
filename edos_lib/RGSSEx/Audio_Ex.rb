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