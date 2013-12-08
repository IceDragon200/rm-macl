#
# rm-macl/lib/rm-macl/xpan/dimension_cells/dimension_cells.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/xpan/dimension_cells/dimension_cells_base'
module MACL
  class DimensionCells < DimensionCellsBase

    ##
    # negate!
    def negate!
      @data.map!(&:-@)
      self
    end

    ##
    # affirm!
    def affirm!
      @data.map!(&:+@)
      self
    end

    ##
    # negate
    def negate
      dup.negate!
    end

    ##
    # affirm
    def affirm
      dup.affirm!
    end

    ##
    # inc!
    def inc!
      data.each_with_index do |n, i|
        data[i] = n + 1
      end
      return self
    end

    ##
    # dec!
    def dec!
      data.each_with_index do |n, i|
        data[i] = n - 1
      end
      return self
    end

    ##
    # inc
    def inc
      return dup.inc!
    end

    ##
    # dec
    def dec
      return dup.dec!
    end

    def add!(*args)
      bang_do!(*args) { |num, i| @data[i] += num }
    end

    def sub!(*args)
      bang_do!(*args) { |num, i| @data[i] -= num }
    end

    def mul!(*args)
      bang_do!(*args) { |num, i| @data[i] *= num }
    end

    def div!(*args)
      bang_do!(*args) { |num, i| @data[i] /= (num == 0 ? 1 : num) }
    end

    def add_at!(*args)
      bang_at_do!(*args) { |num, *coords| self[*coords] += num }
    end

    def sub_at!(*args)
      bang_at_do!(*args) { |num, *coords| self[*coords] -= num }
    end

    def mul_at!(*args)
      bang_at_do!(*args) { |num, *coords| self[*coords] *= num }
    end

    def div_at!(*args)
      bang_at_do!(*args) { |num, *coords| self[*coords] /= (num == 0 ? 1 : num) }
    end

    def add(*args)
      dup.add!(*args)
    end

    def sub(*args)
      dup.sub!(*args)
    end

    def mul(*args)
      dup.mul!(*args)
    end

    def div(*args)
      dup.div!(*args)
    end

    def add_at(*args)
      dup.add_at!(*args)
    end

    def sub_at(*args)
      dup.sub_at!(*args)
    end

    def mul_at(*args)
      dup.mul_at!(*args)
    end

    def div_at(*args)
      dup.div_at!(*args)
    end

    alias :-@ :negate
    alias :+@ :affirm
    alias :+ :add
    alias :- :sub
    alias :* :mul
    alias :/ :div

    class << self
      public :new
    end

  end
end
MACL.register('macl/xpan/dimension_cell/dimension_cell', '1.2.0')