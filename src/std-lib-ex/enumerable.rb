#
# src/std-lib-ex/enumerable.rb
#
module Enumerable

  def pick
    self[rand(self.size)]
  end unless method_defined?(:pick)

  def reverse_index(obj=nil)
    if block_given? ; size.downto(0) do |i| return i if yield(self[i]) end
    else            ; size.downto(0) do |i| return i if self[i] == obj end
    end
    return nil
  end

end
