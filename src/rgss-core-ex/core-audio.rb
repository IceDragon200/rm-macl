#
# src/rgss-core-ex/core-audio.rb
# vr 1.20
module Audio

  @@vol_rate = {
    default: 1.0,
    bgm: 1.0,
    bgs: 1.0,
    me: 1.0,
    se: 1.0
  }

  def self.vol_rate(sym)
    return @@vol_rate[sym]
  end

  def self.vol_rate_set(sym, value)
    @@vol_rate[sym] = value
  end

end

module MACL
  module Mixin

    module AudioVolume

      def audio_sym
        :default
      end

      def audio_path
        'audio/%s'
      end

      def vol_rate
        return Audio.vol_rate(audio_sym)
      end

      def volume_abs
        @volume
      end

      def volume
        return volume_abs * vol_rate
      end

    end

  end
end

module RPG
  class BGM

    include MACL::Mixin::AudioVolume

    def audio_sym
      return :bgm
    end

    def audio_path
      return 'audio/bgm/%s'
    end

    def play(pos=0)
      nm = self.name
      if nm.empty?
        Audio.bgm_stop
        @@last = RPG::BGM.new
      else
        Audio.bgm_play(audio_path % nm, self.volume, self.pitch, pos)
        @@last = self.clone
      end
    end

  end
end

module RPG
  class BGS

    include MACL::Mixin::AudioVolume

    def audio_sym
      return :bgs
    end

    def audio_path
      return 'audio/bgs/%s'
    end

    def play(pos=0)
      nm = self.name
      if nm.empty?
        Audio.bgs_stop
      else
        Audio.bgs_play(audio_path % nm, self.volume, self.pitch, pos)
      end
    end

  end
end

module RPG
  class ME

    include MACL::Mixin::AudioVolume

    def audio_sym
      return :me
    end

    def audio_path
      return 'audio/me/%s'
    end

    def play
      nm = self.name
      if nm.empty?
        Audio.me_stop
      else
        Audio.me_play(audio_path % nm, self.volume, self.pitch)
      end
    end

  end
end

module RPG
  class SE

    include MACL::Mixin::AudioVolume

    def audio_sym
      return :se
    end

    def audio_path
      return 'audio/se/%s'
    end

    def play
      nm = self.name
      Audio.se_play(audio_path % nm, self.volume, self.pitch) unless nm.empty?
    end

  end
end
