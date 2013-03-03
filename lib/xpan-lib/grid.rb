#
# RGSS3-MACL/lib/xpan-lib/grid.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 0.5.0
module MACL
  class Grid

    attr_accessor :columns, :rows
    attr_accessor :cell_width, :cell_height

    def self.qcell_r(columns, rows, cell_width, cell_height, index=0)
      new(columns,rows,cell_width,cell_height).cell_r index
    end

    def initialize(columns=1, rows=1, cell_width=1, cell_height=1)
      @columns,@rows,@cell_width,@cell_height=columns,rows,cell_width,cell_height
    end

    def width
      columns * cell_width
    end

    def height
      rows * cell_height
    end

    def area1
      rows*columns
    end

    def area2
      width*height
    end

    def cell_a index=0,y=nil
      return [0,0,0,0] if columns == 0
      index = xy2index index,y if y
      [cell_width*(index%columns),
       cell_height*(index/columns),
       cell_width,cell_height]
    end

    def cell_r index=0,y=nil
      Rect.new 0,0,0,0 if columns == 0
      index = xy2index index,y if y
      Rect.new(
        cell_width*(index%columns),
        cell_height*(index/columns),
        cell_width,cell_height
      )
    end

    def xy2index x,y
       x % columns  +  y * columns
    end

    def column_r x
      Rect.new cell_width * x,0,cell_width,cell_height * rows
    end

    def row_r y
      Rect.new 0,cell_height*y,cell_width*columns,cell_height
    end

    # // Column, index array
    def column_ia x
      (0...rows).map { |y| xy2index x,y }
    end

    # // Row, index array
    def row_ia y
      (0...columns).map { |x| xy2index x,y }
    end

  end

  class Grid_Matrix < Grid
    # TODO
  end
end
#-end:
