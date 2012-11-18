class Bitmap

  include Disposable

  attr_reader :width, :height
  attr_reader :filename

  def try_exts(filename)
    # // If the filename already has an extension return it
    return filename unless File.extname(filename).empty? 
    # // Else try to find the matching image
    ['.png', '.jpg', '.bmp'].each do |ext|
      new_fn = filename + ext
      return new_fn if File.exist?(new_fn)
    end
    # // Worse case scenario the file could not be found
    return nil
  end

  def initialize(*args)
    return warn 'Cannot create bitmaps' unless $rgx3_gosu
    return warn 'Cannot create bitmaps without window' unless Main.window
    case n = args.size
    when 1
      @filename, = args
      @filename = File.expand_path(@filename)
      @filename = try_exts(@filename) || @filename
      raise(StandardError, "#{@filename} does not exist") unless File.exist?(@filename)
      @width, @height = 1, 1
      @data = Gosu::Image.new(Main.window, @filename, false)
      @width = @data.width
      @height = @data.height
    when 2
      @filename = ':'
      @width, @height = args
      raise(TypeError, 'width must be type Integer or Bignum') unless @width.is_a?(Integer) or @width.is_a?(Bignum)
      raise(TypeError, 'height must be type Integer or Bignum') unless @height.is_a?(Integer) or @height.is_a?(Bignum)
      raise(ArgumentError, 'width cannot be less than or equal to 0') if @width <= 0 
      raise(ArgumentError, 'height cannot be less than or equal to 0') if @height <= 0   
      raise(ArgumentError, "width(#{@width}) must be between 1..1020") if @width > 1020
      raise(ArgumentError, "height(#{@heigt}) must be between 1..1020") if @height > 1020
      @data = TexPlay.create_image(Main.window, @width, @height, color: Color.new(0, 0, 0).to_gosu)
      #@data = TexPlay.create_image(Main.window, 1020, 1020, color: Color.new(0,0,0).to_gosu)
      #TexPlay.create_image(Main.window, @width, @height, color: Color.new(0,0,0).to_gosu)
    else
      raise(ArgumentError, "#{n} for 1..2")
    end
    @rect = Rect.new 0, 0, @width, @height
  end

  def rect
    @rect.dup
  end

  attr_reader :data

  def blt x, y, bmp, rect, opacity=255
    @data.splice(bmp.data, x, y, alpha_blend: true, crop: rect.to_a)
    self
  end

  def clear 
    @data.fill 0, 0, @width, @height, color: Color.new(0, 0, 0, 0).to_gosu
  end

  def draw_text *args
    #warn 'Unsupported function %s' % __method__.to_s
    case args.size
    # // rect, text[, align]
    when 2..3

    # // x, y, w, h, text[, align]  
    when 5..6

    else
      raise(ArgumentError, '2..3 or 5..6')
    end
  end

end
