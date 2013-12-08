#
# rm-macl/lib/rm-macl/vxa-ext/rpg/event-page.rb
#   by IceDragon
module RPG
  class Event
    class Page

      COMMENT_CODES = [108,408]

      def select_commands(*codes)
        @list.select do |c| codes.include?(c.code) end
      end

      def comments
        select_commands(*COMMENT_CODES)
      end

      def comments_a
        comments.map(&:parameters).flatten
      end

    end
  end
end
MACL.register('macl/vxa/rpg/event/page', '1.1.0')