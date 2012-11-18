#-//log:
#-// ~ヾ(＾∇＾)
#-//eval $walk_command = 0.1
#-switch INCUR:ON
#-// Definitions
#-define xMACLBUILD:
#-define DIRGTWD#=__THISDIR__/..
#-define SRCPATH#=DIRGTWD/src
#-define _HEADER#=__THISDIR__/header.rb
#-define _FOOTER#=__THISDIR__/footer.rb
#-define _STDLBEX#=SRCPATH/std-lib-ex
#-define _MACLPATH#=SRCPATH/macl
#-define _RGSSExPTH#=SRCPATH/rgss-ex
#-define _RPGPTH#=SRCPATH/rpg-ex
#-define _GMCLSPTH#=SRCPATH/gm-classes
#-define _GMMODPTH#=SRCPATH/gm-modules
#-unlessdef xONLYSTDLIB
  #-// xpanlibex?
  #-define XPANLIB:
  #-ifdef XPANLIB
    #-define _XPANLBEX#=SRCPATH/xpan-lib
  #-end:
#-end:
#-// Include Headers
#-include _HEADER
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
#-include _FOOTER
