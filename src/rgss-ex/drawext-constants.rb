module DrawExt
  def self.quick_bar_colors(color)
    c = color.dup
    return {
      :bar_outline1 => c.add(0.33),
      :bar_outline2 => c.subtract(0.25),
      :bar_inner1   => c,
      :bar_inner2   => c.subtract(0.42),
    }
  end  
  GREEN_BAR_COLORS = {
    :bar_outline1  => Color.new( 117, 205,  85, 255 ),
    :bar_outline2  => Color.new(  66, 154,  34, 255 ),
    :bar_inner1    => Color.new(  91, 179,  59, 255 ),
    :bar_inner2    => Color.new(  42, 130,  10, 255 ),
  }
  BLUE_BAR_COLORS = {
    :bar_outline1  => Color.new( 123, 176, 222, 255 ),
    :bar_outline2  => Color.new(  79, 122, 166, 255 ),
    :bar_inner1    => Color.new(  95, 149, 208, 255 ),
    :bar_inner2    => Color.new(  58,  97, 140, 255 ),
  }
  RED_BAR_COLORS = {
    :bar_outline1  => Color.new( 248,  98,  96, 255 ),
    :bar_outline2  => Color.new( 199,  52,  50, 255 ),
    :bar_inner1    => Color.new( 224,  73,  71, 255 ),
    :bar_inner2    => Color.new( 176,  34,  32, 255 ),
  }
  YELLOW_BAR_COLORS = {
    :bar_outline1  => Color.new( 246, 187,   3, 255 ),
    :bar_outline2  => Color.new( 194, 150,   3, 255 ),
    :bar_inner1    => Color.new( 221, 169,   3, 255 ),
    :bar_inner2    => Color.new( 168, 131,   3, 255 ),
  }
  RUBY_BAR_COLORS = {
    :bar_outline1  => Color.new( 253, 131, 113, 255 ).darken( 0.2 ),
    :bar_outline2  => Color.new( 202,  62,  70, 255 ).darken( 0.1 ),
    :bar_inner1    => Color.new( 194,  55,  65, 255 ),
    :bar_inner2    => Color.new( 107,  19,  43, 255 ),
  }
  METAL1_BAR_COLORS = {
    #:base_outline1 => Color.new(  36,  34,  30, 255 ),
    #:base_outline2 => Color.new(  16,  15,  14, 255 ),
    #:base_inner1   => Color.new(  95,  86,  69, 255 ).darken( 0.3 ),
    #:base_inner2   => Color.new(  81,  71,  52, 255 ).darken( 0.3 ),
    :bar_outline1  => Color.new( 158, 142, 104, 255 ).lighten( 0.1 ),
    :bar_outline2  => Color.new( 108,  97,  72, 255 ).darken( 0.2 ),
    :bar_inner1    => Color.new( 255, 210, 129, 255 ).darken( 0.2 ),
    :bar_inner2    => Color.new( 176, 149,  99, 255 ).darken( 0.5 ),
    :bar_highlight => Color.new( 255, 255, 255,  25 )
  }
  METAL2_BAR_COLORS = {
    :bar_outline1  => Color.new(  89,  88,  83, 255 ).lighten( 0.7 ),
    :bar_outline2  => Color.new(  48,  47,  43, 255 ).lighten( 0.7 ),
    :bar_inner1    => Color.new( 225, 223, 212, 255 ),
    :bar_inner2    => Color.new( 111, 108,  98, 255 ),
    :bar_highlight => Color.new( 255, 255, 255,  25 )
  }
  TRANS_BAR_COLORS = {
    #:base_outline1 => Color.new(  36,  34,  30, 255 ),
    #:base_outline2 => Color.new(  16,  15,  14, 255 ),
    :base_inner1   => Pallete[:black].xset(:alpha=>25),
    :base_inner2   => Pallete[:black].xset(:alpha=>25),
    :bar_outline1  => Pallete[:gray15].xset(:alpha=>128),
    :bar_outline2  => Pallete[:gray18].xset(:alpha=>128),
    :bar_inner1    => Pallete[:gray12].xset(:alpha=>96),
    :bar_inner2    => Pallete[:gray15].xset(:alpha=>128),
    :bar_highlight => Pallete[:white].dup.xset(:alpha=>25)
  }
  BLACK_BAR_COLORS = {
    :bar_outline1  => Pallete[:gray15],
    :bar_outline2  => Pallete[:gray18],
    :bar_inner1    => Pallete[:gray12],
    :bar_inner2    => Pallete[:gray15],
    :bar_highlight => Pallete[:white].dup.xset(:alpha=>25)
  }
  BLACK2_BAR_COLORS = {
    :bar_outline1  => Pallete[:gray15],
    :bar_outline2  => Pallete[:gray16],
    :bar_inner1    => Pallete[:gray14],
    :bar_inner2    => Pallete[:gray15],
    :bar_highlight => Pallete[:white].dup.xset(:alpha=>0)
  }
  WHITE_BAR_COLORS = {
    :bar_outline1  => Pallete[:gray5],
    :bar_outline2  => Pallete[:gray8],
    :bar_inner1    => Pallete[:gray2],
    :bar_inner2    => Pallete[:gray5],
    :bar_highlight => Pallete[:white].dup.xset(:alpha=>25)
  }
  HP1_BAR_COLORS = GREEN_BAR_COLORS
  HP2_BAR_COLORS = YELLOW_BAR_COLORS
  HP3_BAR_COLORS = RED_BAR_COLORS
  MP_BAR_COLORS  = BLUE_BAR_COLORS
  WT_BAR_COLORS  = BLACK_BAR_COLORS
  DEF_BAR_COLORS = { 
    :base_outline1 => Color.new(  28,  28,  28, 255 ),
    :base_outline2 => Color.new(  28,  28,  28, 255 ),
    :base_inner1   => Color.new(  71,  71,  71, 255 ),
    :base_inner2   => Color.new(  61,  61,  61, 255 ),
    :bar_outline1  => Color.new( 117, 205,  85, 255 ),
    :bar_outline2  => Color.new(  66, 154,  34, 255 ),
    :bar_inner1    => Color.new(  91, 179,  59, 255 ),
    :bar_inner2    => Color.new(  42, 130,  10, 255 ),
    :bar_highlight => Color.new( 255, 255, 255,  25 ),
  }
  #DEF_BAR_COLORS.merge!( 
  #  {
  #    :base_outline1 => Color.new( 147, 106,  67, 255 ).lighten( 0.1 ), 
  #    :base_outline2 => Color.new( 147, 106,  67, 255 ),
  #    :base_inner1   => Color.new( 129, 102,  79, 255 ),
  #    :base_inner2   => Color.new( 129, 102,  79, 255 ).darken( 0.1 ),
  #  }
  #) 
end  