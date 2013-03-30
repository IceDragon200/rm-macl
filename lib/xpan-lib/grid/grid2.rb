#
# RGSS3-MACL/lib/xpan-lib/grid/grid2.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 30/03/2013
# vr 1.0.0
module MACL
class Grid2

  VERSION = "1.0.0".freeze

  CELL_ORDER_COLS = 0x0
  CELL_ORDER_ROWS = 0x1

  @default_cell_order = CELL_ORDER_COLS

  attr_accessor :columns, :rows
  attr_accessor :cell_width, :cell_height
  attr_reader :cell_order

  ##
  # ::valid_cell_order?(CELL_ORDER order)
  def self.valid_cell_order?(order)
    order == CELL_ORDER_COLS || order == CELL_ORDER_ROWS
  end

  ##
  # ::validate_cell_order(CELL_ORDER order)
  def self.validate_cell_order(order)
    unless valid_cell_order?(order)
      raise(ArgumentError, "Invalid Cell Order #{order}")
    end
  end

  ##
  # ::default_cell_order
  def self.default_cell_order
    return @default_cell_order
  end

  ##
  # ::default_cell_order=(CELL_ORDER new_order)
  def self.default_cell_order=(new_order)
    validate_cell_order(new_order)
    @default_cell_order = new_order
  end

  ##
  # ::cell_r(int cols, int rows, int cell_w, int cell_h, int index)
  # ::cell_r(int cols, int rows, int cell_w, int cell_h, int x, int y)
  def self.cell_r(cols, rows, cell_w, cell_h, *args)
    index = args.size == 1 ? args.first : xy_to_index(*args)
    new(cols, rows, cell_w, cell_h).cell_r(index)
  end

  ##
  # initialize(int cols, int rows, int cell_w, int cell_h)
  def initialize(*args)
    set(*args)
    @cell_order = self.class.default_cell_order
  end

  ##
  # set(int cols, int rows, int cell_w, int cell_h)
  def set(cols, rows, cell_w, cell_h)
    @columns     = cols.to_i
    @rows        = rows.to_i
    @cell_width  = cell_w.to_i
    @cell_height = cell_h.to_i
    self
  end

  ##
  # cell_order=(CELL_ORDER new_order) -> nil
  def cell_order=(new_order)
    self.class.validate_cell_order(new_order)
    @cell_order = new_order
  end

  ##
  # width -> int
  def width
    columns * cell_width
  end

  ##
  # height -> int
  def height
    rows * cell_height
  end

  ##
  # cell_count -> int
  def cell_count
    rows * columns
  end

  ##
  # area -> int
  def area
    width * height
  end

  ##
  # index_to_xy(int x, int y) -> int
  def xy_to_index(x, y)
    case @cell_order
    when CELL_ORDER_COLS then (x % columns) + (y * columns)
    when CELL_ORDER_ROWS then (x * rows) + (y % rows)
    end
  end

  ##
  # index_to_xy(int index) -> Array<int>[2]
  def index_to_xy(index)
    case @cell_order
    when CELL_ORDER_COLS then [(index % columns), (index / columns)]
    when CELL_ORDER_ROWS then [(index / rows), (index % rows)]
    end
  end

  ##
  # cell_a(int index)    |
  # cell_a(int x, int y) |-> Array<int>[4]
  def cell_a(*args)
    case args.size
    when 1 then x, y = index_to_xy(args[0])
    when 2 then x, y = *args
    else        raise(ArgumentError, "Expected 1..2 but recieved #{args.size}")
    end
    [cell_width * x, cell_height * y, cell_width, cell_height]
  end

  ##
  # cell_r(int index)
  # cell_r(int x, int y)
  def cell_r(*args)
    Rect.new(*cell_a(*args))
  end

  ##
  # col_r(x) -> Rect
  #   Returns an Rect of the column (x)
  def col_r(x)
    Rect.new(cell_width * x, 0, cell_width, cell_height * rows)
  end

  ##
  # row_r(y) -> Rect
  #   Returns an Rect of the row (y)
  def row_r(y)
    Rect.new(0, cell_height * y, cell_width * columns, cell_height)
  end

  ##
  # col_ia(int x) => Array<int>
  #   Returns an Array of indecies for colummn (x)
  def col_ia(x)
    (0...rows).map { |y| xy_to_index(x, y) }
  end

  ##
  # row_ia(int y) => Array<int>
  #   Returns an Array of indecies for row (y)
  def row_ia(y)
    (0...columns).map { |x| xy_to_index(x, y) }
  end

end
end
