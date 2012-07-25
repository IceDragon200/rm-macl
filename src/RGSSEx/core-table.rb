#-apndmacro _imported_
#-inject gen_scr_imported 'Core-Table', '0x10001'
#-end:
#-inject gen_class_header 'Table'
#-skip:
module MACL
  module Mixin
    module TableExpansion 
    end
  end
end
#-end:
class Table
  include MACL::Mixin::TableExpansion  
end