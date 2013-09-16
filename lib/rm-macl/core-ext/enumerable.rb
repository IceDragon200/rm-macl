#
# RGSS3-MACL/lib/core-ext/enumerable.rb
#
module Enumerable

  def each_with_objects(*args, &block)
    return to_enum(:each_with_objects, *args) unless block_given?
    each do |obj|
      yield obj, *args
    end
  end unless method_defined?(:each_with_objects)

  def map_with_objects(*args, &block)
    return to_enum(:map_with_objects, *args) unless block_given?
    map do |obj|
      yield obj, *args
    end
  end unless method_defined?(:map_with_objects)

end