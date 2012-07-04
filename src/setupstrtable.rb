# // 04/21/2012
# // 04/21/2012
begin
  folds = {
    "database" => [
      [:file, "actors.ini" , "[ACTORS]"],
      [:file, "enemies.ini", "[ENEMIES]"],
      [:file, "classes.ini", "[CLASSES]"],
      [:file, "items.ini"  , "[ITEMS]"],
      [:file, "skills.ini" , "[SKILLS]"],
      [:file, "weapons.ini", "[WEAPONS]"],
      [:file, "armors.ini" , "[ARMORS]"],
      [:file, "states.ini" , "[STATES]"]
    ],
    "system" => [
      [:file, "params.ini"]
    ],
  }
  unless File.exist? "BUILD.inf"
    File.open "BUILD.inf","w+"  do |f|
      f.puts "[STRING_TABLE]"
      f.puts "LANGUAGE=RUBY"
      f.puts "GAMEVERSION=0.1"
      f.puts "TABLEVERSION=1.0"
    end
  end
  target, = ARGV
  folds.each_pair do |k,v|
    pth = target + k
    unless(File.exist?(pth))
      Dir.mkdir(pth)
      puts "Made directory #{pth}"
    end
    v.each do |a|
      fn = pth+"/"+a[1]
      next if(File.exist?(fn))
      case(a[0])
      when :folder
        Dir.mkdir(fn)
        puts "Made directory #{fn}"
      when :file
        File.open(fn,"w+") {|f|f.puts(a[2]) if(a[2])}
        puts "Made file #{fn}"
      end
    end
  end
  sleep 1.0
end