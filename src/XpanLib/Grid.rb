﻿# // 04/12/2012
# // 04/19/2012
class IEI::Grid
  def self.qcell_r(columns,rows,cell_width,cell_height,index=0)
    new(columns,rows,cell_width,cell_height).cell_r(index)
  end  
  def initialize(columns,rows,cell_width,cell_height)
    @columns,@rows,@cell_width,@cell_height=columns,rows,cell_width,cell_height
  end  
  attr_accessor :columns, :rows
  attr_accessor :cell_width, :cell_height
  def width()
    columns * cell_width
  end  
  def height()
    rows * cell_height
  end  
  def cell_r(index=0,y=nil)
    index = xy2index(index,y) if(y)
    Rect.new(
      cell_width*(index%columns),
      cell_height*(index/columns),
      cell_width,cell_height
    )
  end
  def xy2index(x,y)
    (x%columns) + (y*columns)
  end  
  def column_r(x)
    Rect.new(cell_width*x,0,cell_width,cell_height*rows)
  end  
  def row_r(y)
    Rect.new(0,cell_height*y,cell_width*columns,cell_height)
  end  
  # // Column, index array
  def column_ia(x)
    (0...rows).collect{|y|xy2index(x,y)}
  end  
  # // Row, index array
  def row_ia(y)
    (0...columns).collect{|x|xy2index(x,y)}
  end    
end 