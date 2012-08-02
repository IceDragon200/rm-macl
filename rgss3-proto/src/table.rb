class Table

  attr_reader :xsize, :ysize, :zsize

  def initialize *args
    resize *args
  end

  def resize *args
    @xsize, @ysize, @zsize = 1, 1, 1
    case n = args.size
    when 3
      @xsize, @ysize, @zsize = args
    when 2
      @xsize, @ysize = args        
    when 1
      @xsize, = args  
    else
      raise(ArgumentError, "#{n} for 1..3")
    end
    @data = Array.new(@xsize * @ysize * @zsize, 0)
  end

  def [] *args
    x, y, z = 0, 0, 0
    case n = args.size
    when 3
      x, y, z = args
    when 2
      x, y = args        
    when 1
      x, = args  
    else
      raise(ArgumentError, "#{n} for 1..3")
    end
    @data[x + @xsize * y + @xsize * @ysize * z]
  end

  def []= *args
    x, y, z = 0, 0, 0
    case n = args.size
    when 4
      x, y, z, n = args
    when 3
      x, y, n = args        
    when 2
      x, n = args  
    else
      raise(ArgumentError, "#{n} for 2..4")
    end
    @data[x + @xsize * y + @xsize * @ysize * z] = n.to_i
  end

end