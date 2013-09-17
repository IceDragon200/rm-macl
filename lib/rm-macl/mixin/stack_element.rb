#
# rm-macl/lib/rm-macl/mixin/stack_element.rb
#
require 'rm-macl/macl-core'
module MACL
  module Mixin
    module StackElement

      class StackError < RuntimeError
      end

      ##
      # prev_stack_element -> StackElement || nil
      #   the previous StackElement which appeared in the series
      attr_accessor :prev_stack_element

      ##
      # next_stack_element -> StackElement || nil
      #   the next StackElement which appears in the series
      attr_accessor :next_stack_element

      ##
      # stack_next -> StackElement
      #   shortcut for next_stack_element
      def stack_next
        @next_stack_element
      end

      ##
      # stack_prev -> StackElement
      #   shortcut for prev_stack_element
      def stack_prev
        @prev_stack_element
      end

      ##
      # stack_top -> StackElement
      #   queries the current StackElement and asks for the top most element
      def stack_top
        @next_stack_element ? @next_stack_element.stack_top : self
      end

      ##
      # stack_bottom -> StackElement
      #   queries the current StackElement and asks for the bottom most element
      def stack_bottom
        @prev_stack_element ? @prev_stack_element.stack_bottom : self
      end

      ##
      # stack_top_size -> Integer
      #   from this StackElement calculate the size to the top
      def stack_top_size(i=0)
        i += 1
        @next_stack_element ? @next_stack_element.stack_top_size(i) : i
      end

      ##
      # stack_bottom_size -> Integer
      #   from this StackElement calculate the size to the bottom
      def stack_bottom_size(i=0)
        i += 1
        @prev_stack_element ? @prev_stack_element.stack_bottom_size(i) : i
      end

      ##
      # stack_remove -> self
      #   Removes this StackElement from the list and hands its next_stack_element
      #   over to prev_stack_element
      #   If you wish to remove the StackElement and its descendants; use:
      #     #stack_chop instead
      #   Recommended alternative #stack_remove_next
      def stack_remove
        @prev_stack_element.next_stack_element = @next_stack_element if @prev_stack_element
        @next_stack_element.prev_stack_element = @prev_stack_element if @next_stack_element
        self
      end

      ##
      # stack_remove_next -> StackElement || nil
      #   Removes the next StackElement in the stack, setting the current
      #   next_stack_element to the removed StackElement's next_stack_element
      def stack_remove_next
        @next_stack_element ? @next_stack_element.stack_remove : nil
      end

      ##
      # stack_remove_prev -> StackElement || nil
      #   Removes the previous StackElement in the stack, setting the current
      #   prev_stack_element to the removed StackElement's next_stack_element
      def stack_remove_prev
        @prev_stack_element ? @prev_stack_element.stack_remove : nil
      end

      ##
      # stack_pop -> StackElement
      #   queries the current StackElement and asks for the top most element
      def stack_pop
        if @next_stack_element
          @next_stack_element.stack_pop
        else
          stack_remove
        end
      end

      ##
      # stack_push(StackElement stack_element) -> self
      #   Adds the stack_element to the top of the stack
      def stack_push(stack_element)
        if @next_stack_element
          @next_stack_element.stack_push(stack_element)
        else
          @next_stack_element = stack_element.stack_bottom
          @next_stack_element.prev_stack_element = self
        end
        self
      end

      ##
      # stack_shift -> self
      #   removes the stack_element from the bottom of the stack
      def stack_shift
        if @prev_stack_element
          @prev_stack_element.stack_shift
        else
          stack_remove
        end
      end

      ##
      # stack_unshift(StackElement stack_element) -> self
      #   Adds the stack_element to the bottom of the stack
      def stack_unshift(stack_element)
        if @prev_stack_element
          @prev_stack_element.stack_unshift(stack_element)
        else
          @prev_stack_element = stack_element.stack_top
          @prev_stack_element.next_stack_element = self
        end
        self
      end

      ##
      # stack_insert(StackElement stack_element) -> StackElement
      #   Insert the stack_element between this element and the next
      def stack_insert(stack_element)
        top    = stack_element.stack_top
        bottom = stack_element.stack_bottom
        top.next_stack_element = @next_stack_element
        @next_stack_element.prev_stack_element = top if @next_stack_element
        @next_stack_element = bottom
        @next_stack_element.prev_stack_element = self
        stack_element
      end

      ##
      # stack_prepend(StackElement stack_element) -> StackElement
      #   Insert the stack_element between this element and the prev
      def stack_prepend(stack_element)
        if @prev_stack_element
          @prev_stack_element.stack_insert(stack_element)
        else
          @prev_stack_element = stack_element.stack_top
          @prev_stack_element.next_stack_element = self
        end
        stack_element
      end

      ##
      # stack_stump -> StackElement
      #   Removes the StackElement and returns it with all ancestors
      def stack_stump
        @next_stack_element.prev_stack_element = nil if @next_stack_element
        @next_stack_element = nil
        self
      end

      ##
      # stack_chop -> StackElement
      #   Removes the StackElement and returns it with all descendants
      def stack_chop
        @prev_stack_element.next_stack_element = nil if @prev_stack_element
        @prev_stack_element = nil
        self
      end

      ##
      # stack_next_nth(Integer nth_index) -> StackElement || nil
      #   Gets the nth StackElement in the series, may return nil, if the
      #   index went outside the stack size
      def stack_next_nth(nth_index)
        res = self
        nth_index.times { res = res.stack_next; break if res.nil? }
        return res
      end

      ##
      # stack_prev_nth(Integer nth_index) -> StackElement || nil
      #   Gets the nth previous StackElement in the series, may return nil, if the
      #   index went outside the stack size
      def stack_prev_nth(nth_index)
        res = self
        nth_index.times { res = res.stack_prev; break if res.nil? }
        return res
      end

      ##
      # stack_has_next? -> Boolean
      #   Does this stack have a next_stack_element?
      def stack_has_next?
        !@next_stack_element.nil?
      end

      ##
      # stack_has_prev? -> Boolean
      #   Does this stack have a prev_stack_element?
      def stack_has_prev?
        !@prev_stack_element.nil?
      end

    end
  end
end
MACL.register('macl/mixin/stack_element', '1.1.0')