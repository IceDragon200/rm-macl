#-ifdef xINSTALLED_NOTESCAN_
#-inject gen_module_header 'RPG'
module RPG
#-inject gen_class_header 'BaseItem'
  class BaseItem
    include MACL::Mixin::BaseItem_NoteScan
  end
end
#-end: