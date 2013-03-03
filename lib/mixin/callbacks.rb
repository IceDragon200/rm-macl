#
# RGSS3-MACL/lib/mixin/callbacks.rb
#   by IceDragon
#   dc 03/03/2013
#   dm 03/03/2013
# vr 1.0.0
module MACL
  module Mixin
    module Callback

      def init_handler
        @handler = {}
        return self
      end

      def clear_handler
        @handler.clear
      end

      def dispose_handler
        @handler.clear # clear it, makes sure no one uses the handlers.
        @handler = nil
      end

      ##
      # set_handler(ID sym, Proc func)
      # set_handler(ID sym, &block)
      def set_handler(sym, func=nil, &block)
        if func && block || !func && !block
          raise(ArgumentError,
                "Either pass a block (block), or a Proc (func)")
        end
        (@handler[sym] ||= []).push(func || block)
        return self
      end

      ##
      # unset_handlers(ID sym)
      def unset_handlers(sym)
        @handler.delete(sym)
        return self
      end

      ##
      # call_handler(ID sym, *args, &block)
      def call_handler(sym, *args, &block)
        raise(CallbackError,
              "callback #{sym} does not exist") unless @handler.has_key?(sym)
        return @handler[sym].each { |callback| callback.(*args, &block) }
      end

    end
  end
end
