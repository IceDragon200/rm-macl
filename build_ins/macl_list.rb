#-//log:
#-// ~ヾ(＾∇＾)
#-//eval $walk_command = 0.1
#-switch INCUR:ON
#-// Definitions
#-define xMACLBUILD:
#-define DIRGTWD#=ASMxROOT
#-define SRCPATH#=DIRGTWD/src
#-define _HEADER#=DIRGTWD/headers
#-define _FOOTER#=DIRGTWD/footers
#-define _STDLBEX#=SRCPATH/standardlibex
#-define _MACLPATH#=SRCPATH/macl
#-define _RGSSExPTH#=SRCPATH/rgssex
#-define _RPGPTH#=SRCPATH/rpg
#-define _GMCLSPTH#=SRCPATH/gm-classes
#-define _GMMODPTH#=SRCPATH/gm-modules
#-unlessdef xONLYSTDLIB
  #-// xpanlibex?
  #-define XPANLIB:
  #-ifdef XPANLIB
    #-define _XPANLBEX#=SRCPATH/xpanlib
  #-end:
#-end:
#-// Include Headers
#-include _HEADER/_build_order.rb
#-// Include Scripts
#-include _STDLBEX/_build_order.rb
#-unlessdef xONLYSTDLIB
  #-include SRCPATH/macl/_build_order.rb
  #-ifdef _XPANLBEX
    #-include _XPANLBEX/_build_order.rb
  #-end:
  #-include _RGSSExPTH/_build_order.rb
  #-include _GMMODPTH/_build_order.rb
  #-include _GMCLSPTH/_build_order.rb
  #-include SRCPATH/macl/macl-tail.rb
#-end:
#-// Include Footer
#-include _FOOTER/_build_order.rb