#
# rm-macl/lib/rm-macl/xpan/grid/grid3.rb
#   by IceDragon
#   dc 30/03/2012
#   dm 30/03/2013
# vr 1.0.0
module MACL
  class Grid3

    VERSION = "1.0.0".freeze

    CELL_ORDER_COLS = 1
    CELL_ORDER_ROWS = 2
    CELL_ORDER_LAYS = 3

    @default_cell_order = CELL_ORDER_LAYS

    attr_accessor :columns, :rows, :layers
    attr_accessor :cell_width, :cell_height, :cell_depth
    attr_reader :cell_order

    ##
    # ::valid_cell_order?(CELL_ORDER order)
    def self.valid_cell_order?(order)
      order == CELL_ORDER_COLS ||
      order == CELL_ORDER_ROWS ||
      order == CELL_ORDER_LAYS
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
    # ::cell_cube(int cols, int rows, int cell_w, int cell_h, int index)
    # ::cell_cube(int cols, int rows, int cell_w, int cell_h, int x, int y, int z)
    def self.cell_cube(cols, rows, lays, cell_w, cell_h, cell_d, *args)
      index = args.size == 1 ? args.first : xyz_to_index(*args)
      new(cols, rows, lays, cell_w, cell_h, cell_d).cell_cube(index)
    end

    ##
    # initialize(int cols, int rows, int lays, int cell_w, int cell_h, int cell_d)
    def initialize(*args)
      set(*args)
      @cell_order = self.class.default_cell_order
    end

    ##
    # set(int cols, int rows, int lays, int cell_w, int cell_h, int cell_d)
    def set(cols, rows, lays, cell_w, cell_h, cell_d)
      @columns     = cols.to_i
      @rows        = rows.to_i
      @layers      = lays.to_i
      @cell_width  = cell_w.to_i
      @cell_height = cell_h.to_i
      @cell_depth  = cell_d.to_i
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
    # depth -> int
    def depth
      layers * cell_depth
    end

    ##
    # cell_count -> int
    def cell_count
      rows * columns * layers
    end

    ##
    # volume -> int
    def volume
      width * height * depth
    end

    ##
    # index_to_xyz(int x, int y, int z) -> int
    def xyz_to_index(x, y, z)
      case @cell_order
      when CELL_ORDER_COLS then (x % columns) +
                                  (y * columns) +
                                  (z * columns * rows)
      when CELL_ORDER_ROWS then (x * rows * layers) +
                                  (y % rows) +
                                  (z * rows)
      when CELL_ORDER_LAYS then (x * layers) +
                                  (y * layers * columns) +
                                  (z % layers)
      end
    end

    ##
    # index_to_xy(int index) -> Array<int>[3]
    def index_to_xyz(index)
      case @cell_order
      when CELL_ORDER_COLS then [(index) % columns,
                                   (index / columns) % rows,
                                   (index / (columns * rows)) % layers]
      when CELL_ORDER_ROWS then [(index / (rows * layers)) % columns,
                                   (index) % rows,
                                   (index / rows) % layers]
      when CELL_ORDER_LAYS then [(index / layers) % columns,
                                   ((index / (layers * columns)) % rows),
                                   (index) % layers]
      end
    end

    ##
    # cell_a(int index)           |
    # cell_a(int x, int y, int z) |-> Array<int>[6]
    def cell_a(*args)
      case args.size
      when 1 then x, y, z = index_to_xyz(args[0])
      when 3 then x, y, z = *args
      else        raise(ArgumentError, "Expected 1 or 3 but recieved #{args.size}")
      end
      [cell_width * x, cell_height * y, cell_depth * z,
       cell_width, cell_height, cell_depth]
    end

    ##
    # cell_cube(int index)           |
    # cell_cube(int x, int y, int z) |-> MACL::Cube
    def cell_cube(*args)
      MACL::Cube.new(*cell_a(*args))
    end

    ##
    # col_cube(x, z) -> Cube
    #   Returns an Cube of the column (x, z)
    def col_cube(x, z)
      Cube.new(x * cell_width, 0 * cell_height, z * cell_depth,
               cell_width, cell_height * rows, cell_depth)
    end

    ##
    # row_cube(y, z) -> Cube
    #   Returns an Cube of the row (y, z)
    def row_cube(y, z)
      Cube.new(0 * cell_width, y * cell_height, z * cell_depth,
               cell_width * columns, cell_height, cell_depth)
    end

    ##
    # lay_cube(x, y) -> Cube
    #   Returns an Cube of the row (x, y)
    def lay_cube(x, y)
      Cube.new(x * cell_width, y * cell_height, 0 * cell_depth,
               cell_width, cell_height, cell_depth * layers)
    end

    ##
    # col_ia(int x, int z) -> Array<int>
    #   Returns an Array of indecies for colummn (x, z)
    def col_ia(x, z)
      (0...rows).map { |y| xyz_to_index(x, y, z) }
    end

    ##
    # row_ia(int y, int z) -> Array<int>
    #   Returns an Array of indecies for row (y, z)
    def row_ia(y, z)
      (0...columns).map { |x| xyz_toindex(x, y, z) }
    end

    ##
    # lay_ia(int x, int y) -> Array<int>
    #   Returns an Array of indecies for row (x, y)
    def row_ia(x, y)
      (0...layers).map { |z| xyz_toindex(x, y, z) }
    end

  end
end