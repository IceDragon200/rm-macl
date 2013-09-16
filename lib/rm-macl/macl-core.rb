#
# rm-macl/lib/rm-macl/macl-core.rb
#
# MACL core module, containing version information and a few assistant functions
require 'rm-macl/version'
module MACL

  ##
  # An error which is raised when an extension was already registered
  class Registered < RuntimeError
  end

  ### class-variables
  @@registry = {} #
  @@flags = {}

  ##
  # returns the version of the lib installed, else returns nil
  def self.registered?(sym)
    @@registry[sym] || false
  end

  ##
  # used internally for registering MACL extensions
  def self.register(sym, version_str)
    if vstr = @@registry[sym]
      raise Registered, "#{sym} is already registered as #{vstr}"
    end
    @@registry[sym] = version_str
  end

  ##
  # Sets internal flags used by certain internal macl extensions
  def self.set_flag(sym, value)
    @@flags[sym] = value
  end

  ##
  # Can be overloaded by project, if they have a different way of handling
  # the frame_rate
  def self.frame_rate
    defined?(Graphics) ? Graphics.frame_rate : 60
  end

end
MACL.register('macl/core', '3.0.0')