#
# rm-macl/lib/rm-macl/core-ext/enumerable.rb
#
require 'rm-macl/macl-core'
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
MACL.register('macl/core/enumerable', '1.2.0')