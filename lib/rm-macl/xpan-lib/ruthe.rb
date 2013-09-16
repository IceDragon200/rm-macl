#
# RGSS3-MACL/lib/xpan-lib/ruthe.rb
#   by IceDragon (mistdragon100@gmail.com)
#   dc 24/07/2013
#   dm 24/07/2013
# vr 0.0.1
#   Module/Class Importation (kinda like Lua)
#   USAGE:
#      mod   = MACL::Ruthe.import(filename, type)
#      klass = MACL::Ruthe.import("my_class.rb", Class)
#      mod   = MACL::Ruthe.import("my_module.rb", Module)
module MACL
  module Ruthe
    
    def import(filename, mod, *args)
      # TODO: Find some other way to compile a file to a proc or something else
      mod.new(*args) do
        module_eval(File.read(filename))
        #inseq = RubyVM::InstructionSequence.compile_file(filename) 
        #instance_exec(&inseq) # =.=
      end
    end

    extend self

  end
end