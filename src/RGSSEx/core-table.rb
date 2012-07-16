#-apndmacro _imported_
#-inject gen_scr_imported 'Core-Table', '0x10001'
#-end:
#-inject gen_class_header 'Table'
class Table
  include MACL::Mixin::TableExpansion  
end