#-// 04/19/2012
#-// 04/19/2012
#-inject gen_class_header 'IEI::ArrayTable'
class ArrayTable
  include Mixin::TableExpansion
  attr_reader :xsize
  attr_reader :ysize
  attr_reader :zsize
  CAP = 256 ** 4
  def initialize(*args,&block)
    resize(*args,&block)
  end
  def resize(x,y=1,z=1,&block)
    @xsize, @ysize, @zsize = x.min(CAP), y.minmax(CAP,1), z.minmax(CAP,1)
    @data = Array.new(@xsize * @ysize * @zsize, &block)
  end  
  def [](x, y = 0, z = 0)
    @data[x.min(@xsize) + y.min(@ysize) * @xsize + z.min(@zsize) * @xsize * @ysize]
  end
  def []=(*args)
    x = args[0].min(@xsize)
    y = (args.size > 2 ? args[1] : 0).min(@ysize)
    z = (args.size > 3 ? args[2] : 0).min(@zsize)
    v = args.pop.min(CAP)
    @data[x + y * @xsize + z * @xsize * @ysize] = v
  end
  def reset!()
    @data.clear()
    @xsize, @ysize, @zsize = 0, 0, 0
  end  
end