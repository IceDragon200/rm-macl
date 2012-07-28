require 'C:/Lib/Git/RGSS3-MACL/src/build_tools/skripII/skripII.rb'
filenames = Dir.glob('*.rb').reject do |fn| fn =~ /A_(.+).rb/i end
SkripII.mk_skp! filenames, 'gm-classes.%s', :auto
