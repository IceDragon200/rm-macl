require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../rgss3macl_dev.rb'
  tween = Tween.new [0,0],[100,100],:back_out,Tween.frm2sec(180) 
  @table = ArrayTable.new(120,120)
  x,y,a=nil,nil,nil
  rgss_main do
    loop do
      Main.update
      tween.update
      system("cls")
      puts tween.values.inspect
      x = tween.value(0) 
      y = tween.value(1) 
      a = @table.to_a
      a[x+y*@table.xsize] = '='
      puts a #a.split_every(@table.xsize).join('')
      break if tween.done?
    end 
  end  
end