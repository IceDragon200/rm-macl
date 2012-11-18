require_relative '_rgss3_prototype.rb'
_demo_block do
  require '../src/build_tools/Skinj.rb'
  str = %Q(
#-label PRE
#-wait 1.0
#-ifdef xT
  #-print From xT
#-else:
  #-print From Skinj
#-end:
#-unlessdef xT
  #-define xT
  #-jumpto PRE
#-else:
  #-jumpto POST
#-end: 
#-print Pre End 
#-label POST
#-print Post End
)
  Skinj.skinj_str str
end