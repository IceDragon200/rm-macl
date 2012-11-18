require_relative '_rgss3_prototype.rb'
_demo_block do
  module Woot
    def self.each
      10.times do yield rand(20) end
    end
  end
  for num in Woot
    puts num
  end
end