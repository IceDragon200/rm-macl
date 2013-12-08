#
# rm-macl/lib/rm-macl/xpan/daemon.rb
#   by IceDragon
# Daemon is a background service esque library, it offers a very simple
# system for creating and managing Daemon objects
# This version is slightly different from the rm-rice version,
# since it can support multiple DaemonServers
require 'rm-macl/macl-core'
require 'rm-macl/mixin/log'
module MACL #:nodoc:
  class DaemonServer

    @@current = nil

    include MACL::Mixin::Log

    def initialize
      @daemons = []
      @paused = false
      set_active
    end

    def set_active
      @@current = self
    end

    def unload
      #
    end

    def init_daemons
      @daemons.each do |d|
        if d.respond_to?(:init)
          d.init
          log.puts("[ INIT ] #{d.class.name}") if log
        else
          log.puts("[NOINIT] #{d.class.name}") if log
        end
      end
      refresh!
    end

    def update
      return if @paused
      if @need_refresh
        @need_refresh = false
        refresh!
      end

      #raise(
      #  DaemonError, "Daemon @udaemons have not been set, cannot update Daemon"
      #) unless @udaemons

      unless @udaemons.empty?
        for daemon in @udaemons
          daemon.update
        end
      end
    end

    def add(daemon)
      unless daemon.is_a?(Daemon)
        raise TypeError, "Invalid Daemon: #{daemon} must be a subclass of Daemon"
      end
      @daemons.push(daemon) unless @daemons.include?(daemon)
      @need_refresh = true
    end

    def remove(daemon)
      @daemons.delete(daemon)
      @need_refresh = true
    end

    def halt!
      @daemons.each do |daemon|
        if daemon.respond_to?(:halt!)
          daemon.halt!
          try_log { |log| log.puts("#{daemon}, halted\n") }
        else
          try_log { |log| log.puts("#{daemon}, does not support halt!\n") }
        end
      end
      pause!()
    end

    def pause!
      @paused = true
    end

    def unpause!
      @paused = false
    end

    def refresh!
      @udaemons = @daemons.select do |d|
        d.respond_to?(:update)
      end
    end

    def clear!
      @daemons.clear
      refresh!
    end

    def self.current
      @@current
    end

  end
  ##
  #
  class Daemon

    class DaemonError < Exception
    end

    def initialize
      if server = DaemonServer.current
        server.add(self)
      end
      self.class.current = self
    end

    def dispose
      if server = DaemonServer.current
        server.remove(self)
      end
      self.class.current = nil
    end

    def self.current
      @current
    end

    def self.current=(new_current)
      @current = new_current
    end

  end
end
MACL.register('macl/xpan/daemon', '1.0.0')