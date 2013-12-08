#
# rm-macl/lib/rm-macl/xpan/easer/elastic.rb
#   dc 24/03/2013
#   dm 24/03/2013
# vr 1.0.0
module MACL
  class Easer
    class Elastic < Easer

      attr_accessor :a, :p

      def initialize
        super
        @a, @p = 3, 0
      end

    end
  end
end