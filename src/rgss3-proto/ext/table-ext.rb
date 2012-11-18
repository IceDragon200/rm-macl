class Table

  def datasize
    @xsize * @ysize * @zsize
  end

  private :datasize

  def clear
    @data = Array.new(datasize, 0)
  end

end