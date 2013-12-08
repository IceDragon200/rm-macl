#
# rm-macl/lib/rm-macl/mixin/mathable.rb
#   by IceDragon
require 'rm-macl/macl-core'
module MACL
  module Mixin
    module Mathable

      #def_abstract :add!
      #def_abstract :sub!
      #def_abstract :mul!
      #def_abstract :div!
      #def_abstract :set!

      def add(other)
        dup.add!(other)
      end

      def sub(other)
        dup.sub!(other)
      end

      def mul(other)
        dup.mul!(other)
      end

      def div(other)
        dup.div!(other)
      end

      def set(other)
        dup.set!(other)
      end

      ### aliases
      alias :+ :add
      alias :- :sub
      alias :* :mul
      alias :/ :div

    end
  end
end
MACL.register('macl/mixin/mathable', '1.0.0')