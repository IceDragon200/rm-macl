begin 
  Dir.glob('src/**/*.rb').collect(&File.method(:dirname)).uniq.each do |fn|
    skname = File.basename(fn)
    puts 'Creating _skp for %s' % fn 
    File.open(File.join(fn,'_skp.rb'),?w) do |f|
      f.puts %Q(require 'C:/Lib/Git/RGSS3-MACL/src/build_tools/skripII/skripII.rb')
      f.puts %Q(filenames = Dir.glob('*.rb').reject do |fn| fn =~ /\A_(.+)\.rb/i end)
      f.puts %Q(SkripII.mk_skp! filenames, '#{skname}.%s', :auto)
    end  
  end
rescue Exception => ex
  p ex
  puts ex.backtrace
end
File.open('mk_skps_files.bat',?w) do |f|
  #f.puts '@echo off'
  Dir.glob('src/**/_skp.rb') do |fn|
    fnf = File.expand_path(fn)
    dn = File.dirname(fnf)
    fn2 = File.basename(fnf)
    puts 'Found %s' % fnf
    f.puts 'cd %s' % dn
    f.puts fn2
    f.puts 'echo Packing %s' % File.basename(File.dirname(fnf))
    #f.puts 'del /Q %s' % dn.dump
  end
  f.puts "@echo on\nexit"
end