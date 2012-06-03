# // FenixFyreX
# // Not functional, DO NOT USE
$:.unshift "System/Ruby"
$:.unshift "System/Ruby/_so/"

def load_so(name)
  n = name.split("/")[-1].split('.')[0].downcase
  $:.each do |path|
    begin
      Win32API.new(path+name,"Init_#{n}",'','')
    rescue
      next
    end
  end
end

alias require_old require
def require(name)
  if File.extname(name) == ".so"
    load_so(name)
  else
    require_old(name)
  end    
end