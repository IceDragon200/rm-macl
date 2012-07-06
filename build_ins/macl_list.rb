#-//log:
#-// ~ヾ(＾∇＾)
#-switch INCUR:ON
#-// MACL Build Rev-3
#-// Definitions
#-define xMACLBUILD
#-define DIRGTWD#=ASMxROOT
#-define SRCPATH#=DIRGTWD/src
#-define STDLBEX#=SRCPATH/StandardLibEx
#-define HEADER#=DIRGTWD/headers
#-define RGSSExPTH#=SRCPATH/RGSSEx
#-unlessdef xONLYSTDLIB
  #-// xpanlibex?
  #-define XPANLIB
  #-ifdef XPANLIB
    #-define XPANLBEX#=SRCPATH/XpanLib
  #-end:
#-end:
#-// Include Headers
#-include HEADER/macl_header.rb
#-include HEADER/stdlibex_header.rb
#-unlessdef xONLYSTDLIB
  #-ifdef XPANLIB
    #-include HEADER/xpanlibex_header.rb
  #-end:
  #-include HEADER/rgss3x_header.rb
#-end:
#-include HEADER/macl_header_tail.rb
#-// Include Scripts
#-include STDLBEX/_build_order.rb
#-unlessdef xONLYSTDLIB
  #-include SRCPATH/macl/_build_order.rb
  #-ifdef XPANLBEX
    #-include XPANLBEX/_build_order.rb
  #-end:
  #-include RGSSExPTH/_build_order.rb
  #-include SRCPATH/macl/macl_tail.rb
#-end:
#-include HEADER/macl_footer.rb