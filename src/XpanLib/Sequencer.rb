# // 04/19/2012
# // 04/19/2012
#-inject gen_class_header 'Sequencer'
class Sequencer
  attr_accessor :index
  attr_accessor :maxcount
  attr_accessor :count
  def initialize(s, n=10)
    self.sequence = s
    @index = 0
    @maxcount = n
    reset_count()
  end  
  attr_reader :sequence
  def sequence=(n)
    n = n.to_a if n.is_a?(Range)
    @sequence = n
  end  
  def reset_count
    @count = @maxcount
  end  
  def value
    @sequence[@index]
  end  
  def update
    @count = @count.pred.max(0)
    if @count == 0
      @index = @index.succ.modulo(@sequence.size) 
      @count = @maxcount
    end
  end
end