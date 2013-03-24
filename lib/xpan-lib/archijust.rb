#
# RGSS3-MACL/lib/xpan-lib/archijust.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.2.0

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
      # used on a attr_writer, to only update the variable if it has changed.
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

        module_eval(%Q(
          def #{sym}(*args, &block)
            dup.#{str}(*args, &block)
          rescue(Exception) => ex
            puts "Error Occurred in #{'#{self.class}'}##{sym}"
            raise(ex) unless MACL::Mixin::Archijust.debug?
          end
        ))

        #define_method(sym) do
        #  |*args, &block|
        #
        #  begin
        #    dup.__send__(str, *args, &block)
        #  rescue(Exception) => ex
        #    puts "define_exfunc: Error in #{sym}"
        #    p ex
        #    raise(ex) unless MACL::Mixin::Archijust.debug?
        #  end
        #end
        return self
      end

      def multi_setter(name, *syms)
        module_eval(%Q(
          def #{name}(*args)
            raise(ArgumentError, "expected #{syms.size} args but recieved #{'#{args.size}'}") unless args.size == #{syms.size}
            #{syms.map{|sym|"self.#{sym}"}.join(", ")} = *args
            return self;
          end
        ))
      end

      #
      # type based accessors
      [
        ["int", "%s.to_i"],
        ["float", "%s.to_f"],
        ["string", "%s.to_s"],
        ["bool", "!!%s"]
        #["array", "%s.to_a"],
        #["hash", "%s.to_h"]
      ].each do |(word, conv)|
        module_eval(%Q(
        def #{word}_reader(*syms)
          syms.each do |sym|
            define_method(sym) do
              #{conv % 'instance_variable_get("@#{sym}")'}
            end
          end
        end

        def #{word}_writer(*syms)
          syms.each do |sym|
            define_method("#{'#{sym}'}=") do |n|
              instance_variable_set("@#{'#{sym}'}", #{conv % 'n'})
            end
          end
        end

        def #{word}_accessor(*syms)
          #{word}_reader(*syms)
          #{word}_writer(*syms)
        end))
      end

    end
  end
end
