#
# rm-macl/lib/rm-macl/xpan/ruthe.rb
#   by IceDragon
# Module/Class Importation (kinda like Lua)
#   USAGE:
#      mod   = MACL::Ruthe.import(filename, type)
#      klass = MACL::Ruthe.import("my_class.rb", Class)
#      mod   = MACL::Ruthe.import("my_module.rb", Module)
require 'rm-macl/macl-core'
module MACL #:nodoc:
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
MACL.register('macl/xpan/ruthe', '0.1.0')