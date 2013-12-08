#
# rm-macl/lib/rm-macl/mixin/log.rb
#   by IceDragon
require 'rm-macl/macl-core'
module MACL # :nodoc:
  module Mixin # :nodoc:
    module Log

      attr_accessor :log # IO

      def try_log
        yield(@log) if @log
      end

    end
  end
end
MACL.register('macl/mixin/log', '1.1.0')