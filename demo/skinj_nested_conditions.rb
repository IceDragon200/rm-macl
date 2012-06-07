begin
  require '../src/build_tools/Skinj.rb'
  str = %Q(
#-define Tx
#-undefine xT
#-ifdef Tx
  #-wait 2.0
  #-print Hello from Tx
  #-ifdef xT
    #-print Private from xT
  #-end:
#-end:
)
  Skinj.skinj_str str
  gets
rescue Exception => ex
  p ex
  gets
end