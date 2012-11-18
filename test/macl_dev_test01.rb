require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../builds(ex)/rgss3macl_dev.rb'
  tween  = Tween.new [0,0],[10,10],:back_out,Tween.frm2sec(180)
  @table = MACL::ArrayTable.new 12,12
  x,y,a  = nil,nil,nil
  rgss_main do
    loop do
      Main.update
      tween.update
      system "cls"
      puts tween.values.inspect
      x = tween.value(0)
      y = tween.value(1)
      #a = @table.to_a
      @table[x.to_i,y.to_i] = '='
      p @table.to_a.inspect #a.split_every(@table.xsize).join('')
      break if tween.done?
    end
  end
end