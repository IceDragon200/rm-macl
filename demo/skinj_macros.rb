# // 06/06/2012
# // 06/06/2012
begin
  require '../src/build_tools/Skinj.rb'
  str = %Q(
#-define Cookies#=cookies
#-define Cream#=YAY
#-recmacro Oreo
#-print Cookies    
#-print Cream
#-stopmacro Oreo
#-macro Oreo
#-macro Oreo
#-macro Oreo
#-macro Oreo
)
  Skinj.skinj_str str
  gets
rescue Exception => ex
  p ex
  gets
end