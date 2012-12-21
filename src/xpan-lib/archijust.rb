#
# src/xpan-lib/archijust.rb
# vr 1.10
#

##
# MACL::Mixin::Archijust
#
module MACL
  module Mixin
    module Archijust

      def self.debug?
        false
      end

      ##
      # define_as(Hash<Symbol, Object>)
      #
      # define a method which will return a static Object
      #
      # EG.
      #   define_as(default_opacity: 198)
      #
      def define_as(hash)
        hash.each_pair do
          |method_name, value|

          define_method(method_name) do value end
        end
      end

      ##
      # define_uoc(Symbol *syms)
      #
      # used on a attr_writer, to only update the variable if it has changed
      # the original method will be aliased under set_<original_name>
      #
      def define_uoc(*syms)
        syms.each do |sym|
          alias_method "set_#{sym}", "#{sym}="
          module_eval %Q(
            def #{sym}=(n)
              set_#{sym}(n) if(@#{sym} != n)
            end
          )
        end
      end

      ##
      # define_clamp_writer(Hash<Symbol, int[2]> hash)
      #
      # Defines a clamping function, for use with Numeric Object types
      #
      # EG.
      #   define_clamp_writer(symbol: [floor, ceil])
      #   define_clamp_writer(opacity: [0, 255])
      #   opacity = -12 #=> 0
      #
      def define_clamp_writer(hash)
        hash.each_pair do |method_name, v|
          if method_name.is_a?(Array)
            method_name, variable_name = *method_name

            # Error Handling
            warn(
              "#{self}.define_clamp_writer (function: #{method_name}): #{variable_name} is not a valid variable, errors may occur"
            ) unless ["@", "@@", "$"].any? { |s| variable_name.start_with?(s) }
          else
            variable_name = "@#{method_name}"
            method_name = method_name
          end

          floor, ceil = *v
          module_eval %Q(
            def #{method_name}=(n)
              #{variable_name} = n < #{floor} ? #{floor} : (n > #{ceil} ? #{ceil} : n)
            end
          )
        end
      end

      ##
      # define_exfunc(Symbol sym, &func)
      #
      # creates a bang function from the given symbol and func
      #   Your original method will be the bang method, it is expected that
      #   the Object that you use this method with, will be dup-able
      #
      # EG.
      #   define_exfunc(:fly) do
      #     ...your_normal_method_stuff
      #   end
      #
      def define_exfunc(sym, &func)
        str = sym.to_s + '!' # append ! to the function name

        define_method(str, &func)

        define_method(sym) do
          |*args, &block|

          begin
            dup.__send__(str, *args, &block)
          rescue Exception => ex
            puts "define_exfunc: Error in #{sym}"
            p ex
            raise(ex) unless MACL::Mixin::Archijust.debug?
          end
        end
        return self
      end

    end
  end
end
