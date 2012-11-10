module Enumerable

  def sync_sort!
  end

  def sync_sort
    dup.sync_sort!
  end

end
