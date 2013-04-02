#
# RGSS3-MACL/lib/mixin/callbacks.rb
#   by IceDragon
#   dc 03/03/2013
#   dm 09/03/2013
# vr 1.1.3
module MACL
module Mixin
module Callback

  class CallbackError < RuntimeError
  end

  class << self
    attr_accessor :log
  end

  attr_accessor :callback_log

  def init_callbacks
    @callback_log = ::MACL::Mixin::Callback.log # for debugging
    @callback = {}
    return self
  end

  def clear_callbacks
    @callback.clear
  end

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
    return self
  end

  ##
  # remove_callback(ID sym)
  def remove_callback(sym)
    init_callbacks unless @callback
    @callback.delete(sym)
    return self
  end

  ##
  # callback?(sym)
  def callback?(sym)
    return @callback.has_key?(sym)
  end

  ##
  # call_callback(ID sym, *args, &block)
  def call_callback(sym, *args, &block)
    init_callbacks unless @callback
    raise(CallbackError,
          "callback #{sym} does not exist") unless callback?(sym)
    @callback_log << "Callback: #{self} #{sym} #{args.inspect}\n" if @callback_log
    return @callback[sym].each { |callback| callback.(*args, &block) }
  end

  ##
  # try_callback(ID sym, *args, &block)
  def try_callback(sym, *args, &block)
    call_callback(sym, *args, &block) if callback?(sym)
  end

  alias :callback :call_callback

  private :callback,
          :call_callback,
          :try_callback

end
end
end
