#-// Drool A per line processor
#-// By IceDragon
#-apndmacro _imported_ 
#-inject gen_scr_imported 'MACL::Drool', '0x10000'
#-end:
#-inject gen_class_header 'MACL::Drool'
module MACL
  class Drool
    attr_accessor :list,:index,:default
    def initialize list=[]
      @list  = list
      @index = 0
      @default = nil
    end
    def change_list list
      @list = list
      reset
    end
    def current
      @list[@index] || @default
    end
    def jump_to index
      @index = index
      self
    end
    def prev
      @index -= 1
      self
    end
    def next
      @index += 1
      self
    end
    def reset
      @index = 0
    end
    def done?
      @index >= @list.size
    end
  end
end