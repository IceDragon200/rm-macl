#-unlessdef SRCPATH
  #-define SRCPATH#=C:/Lib/Git/RGSS3-MACL/src/
#-end:
#-define __MaCLSRC#=SRCPATH/MACL
#-include __MaCLSRC/macl.rb
#-include __MaCLSRC/macl-constants.rb
#-include __MaCLSRC/macl-mixins.rb
#-ifdef xMACLDEVBLD
  #-include __MaCLSRC/macl-handle.rb
  #-include __MaCLSRC/macl-parsers.rb
#-end:  