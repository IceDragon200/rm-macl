require File.join(File.dirname(__FILE__), 'common.rb')

class Foo

  include MACL::Mixin::StackElement

  def to_s
    "#{self.class.name} remaining elements #{stack_size}"
  end

end

def foo
  Foo.new
end

obj = foo
10.times do
  obj = obj.stack_push(foo)
end
p obj.stack_next_nth(8)
