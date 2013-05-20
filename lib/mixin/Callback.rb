#
# RGSS3-MACL/lib/mixin/callbacks.rb
#   by IceDragon
#   dc 03/03/2013
#   dm 22/04/2013
# vr 1.1.5
module MACL
module Mixin
module Callback

  class CallbackError < RuntimeError
  end

  extend MACL::Mixin::Log

  attr_accessor :callback_log # IO

  ##
  # init_callbacks
  def init_callbacks
    @callback_log = MACL::Mixin::Callback.log # for debugging
    @callback = {}
    @callback_settings = {
      args_prepend: [],
      args_append: []
    }
  end

  ##
  # clear_callbacks
  def clear_callbacks
    @callback.clear
  end

  ##
  # dispose_callbacks
  def dispose_callbacks
    @callback = nil
  end

  ##
  # add_callback(ID sym, Proc func)
  # add_callback(ID sym, &block)
  def add_callback(sym, func=nil, &block)
    init_callbacks unless @callback
    if func && block || !func && !block
      raise(ArgumentError,
            "Either pass a block (block), or a Proc (func)")
    end
    (@callback[sym] ||= []).push(func || block)
  end

  ##
  # remove_callback(ID sym)
  def remove_callback(sym)
    init_callbacks unless @callback
    @callback.delete(sym)
  end

  ##
  # callback?(ID sym)
  def callback?(sym)
    @callback.has_key?(sym)
  end

  ##
  # call_callback(ID sym, void *args, &block)
  def call_callback(sym, *args, &block)
    init_callbacks unless @callback
    raise(CallbackError,
          "callback #{sym} does not exist") unless callback?(sym)

    if @callback_log
      @callback_log.puts("Callback: #{self} #{sym} #{args.inspect}")
    end

    nargs = args
    unless (apn = @callback_settings[:args_append]).empty?
      nargs.concat(apn)
    end
    unless (pre = @callback_settings[:args_prepend]).empty?
      nargs.replace(pre.concat(nargs))
    end
    @callback[sym].each { |callback| callback.(*nargs, &block) }
    true
  end

  ##
  # try_callback(ID sym, *args, &block)
  def try_callback(sym, *args, &block)
    call_callback(sym, *args, &block) if callback?(sym)
  end

  ##
  # callbacks -> Array<Key>
  def callbacks
    @callback.keys
  end

  alias :callback :call_callback

  private :init_callbacks,
          :callback,
          :call_callback,
          :try_callback

end
end
end
