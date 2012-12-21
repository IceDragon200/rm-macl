##
# MSurface
#
# Surface Mixin
#   exfuncs
module MACL::Mixin::Surface

  define_exfunc 'contract' do
    |hash|
    Hash.type_check(hash)

    anchor = hash[:anchor]
    n      = hash[:amount]

    a = [0, 0, 0, 0]

    a = case anchor
    when 0  ; [ 0, 0,  0,  0]
    when 1  ; [ 0, n, -n, -n]
    when 2  ; [ 0, n,  0, -n]
    when 3  ; [ n, n, -n, -n]
    when 4  ; [ 0, 0, -n * 2, 0]
    when 5  ; [ n, n, -n * 2, -n * 2]
    when 6  ; [ n, 0, -n,  0]
    when 7  ; [ 0, 0, -n, -n]
    when 8  ; [ 0, 0,  0, -n * 2]
    when 9  ; [ n, 0, -n, -n]
    when 28 ; [ 0, n,  0, -n * 2]
    when 46 ; [ n, 0, -n * 2, 0]
    else
      raise(SurfaceAnchorError.mk(anchor))
    end

    self.x      += a[0]
    self.y      += a[1]
    self.width  += a[2]
    self.height += a[3]

    return self
  end

  define_exfunc 'expand' do
    |hash|
    Hash.type_check(hash)

    hash = hash.dup
    hash[:amount] = -hash[:amount]

    return contract!(hash)
  end

  define_exfunc 'squeeze' do
    |hash|
    Hash.type_check(hash)

    anchor = hash[:anchor]
    n      = hash[:amount]

    a = case anchor
    when 0  ; [ 0, 0,  0,  0]
    when 1  ; [ n, 0, -n, -n]
    when 2  ; [ 0, 0,  0, -n]
    when 3  ; [ 0, 0, -n, -n]
    when 4  ; [ n, 0, -n,  0]
    #when 5  ; [ n, n, -n, -n]
    when 6  ; [ 0, 0, -n,  0]
    when 7  ; [ n, n, -n, -n]
    when 8  ; [ 0, n,  0, -n]
    when 9  ; [ 0, n, -n, -n]
    when 28 ; [ 0, n,  0, -n]
    when 46 ; [ n, 0, -n,  0]
    else
      raise(SurfaceAnchorError.mk(anchor))
    end

    self.x      += a[0]
    self.y      += a[1]
    self.width  += a[2]
    self.height += a[3]

    return self
  end

  define_exfunc 'release' do
    |hash|
    Hash.type_check(hash)

    hash = hash.dup
    hash[:amount] = -hash[:amount]

    return squeeze!(hash)
  end

  define_exfunc 'xpush' do
    |hash|
    Hash.type_check(hash)

    anchor = hash[:anchor]
    n      = hash[:amount]

    a = case anchor
    when 0  ; [  0,  0]

    when 1  ; [  n, -n]
    when 2  ; [  0, -n]
    when 3  ; [ -n, -n]

    when 4  ; [  n,  0]

    when 6  ; [ -n,  0]

    when 7  ; [  n,  n]
    when 8  ; [  0,  n]
    when 9  ; [ -n,  n]
    else
      raise(SurfaceAnchorError.mk(anchor))
    end

    self.x += a[0]
    self.y += a[1]

    return self
  end

  define_exfunc 'xpull' do
    |hash|
    Hash.type_check(hash)

    hash = hash.dup
    hash[:amount] = -hash[:amount]

    return xpush!(hash)
  end

  define_exfunc 'align_to' do
    |hash|
    Hash.type_check(hash)

    anchor = hash[:anchor]
    r      = hash[:canvas] || Graphics.rect

    MACL::Mixin::Surface.type_check(r)

    a = case anchor
    when 0  ; [self.x, self.y]

    when 1  ; [r.x, r.y2 - self.height]
    when 2  ; [r.calc_mid_x(self.width), r.y2 - self.height]
    when 3  ; [r.x2 - self.width, r.y2 - self.height]

    when 4  ; [r.x,  r.calc_mid_y(self.height)]
    when 5  ; [r.calc_mid_x(self.width), r.calc_mid_y(self.height)]
    when 6  ; [r.x2 - self.width, r.calc_mid_y(self.height)]

    when 7  ; [r.x, r.y]
    when 8  ; [r.calc_mid_x(self.width), r.y]
    when 9  ; [r.x2 - self.width, r.y]

    # vertical-mid
    when 28 ; [self.x, r.calc_mid_y(self.height)]
    # horizontal-mid
    when 46 ; [r.calc_mid_x(self.width), self.y]

    # horizontal-left
    when 40 ; [r.x, self.y]
    # horizontal-right
    when 60 ; [r.x2 - self.width, self.y]

    # vertical-bottom
    when 20 ; [self.x, r.y2 - self.height]
    # vertical-top
    when 80 ; [self.x, r.y]

    else
      raise(SurfaceAnchorError.mk(anchor))
    end

    self.x = a[0]
    self.y = a[1]

    return self
  end

  alias salign align_to
  alias salign! align_to!

  ##
  # Can be considered an alternative to xpush, uses the Surface's own
  # width and height, with a rate, rather than static values.
  #
  define_exfunc 'offset' do
    |hash|
    Hash.type_check(hash)

    anchor = hash[:anchor]
    n = hash[:rate].to_f

    a = case anchor
    when 0  ; [0, 0]

    when 1  ; [-n, -n]
    when 2  ; [ 0, -n]
    when 3  ; [ n, -n]

    when 4  ; [-n,  0]

    when 6  ; [ n,  0]

    when 7  ; [-n,  n]
    when 8  ; [ 0,  n]
    when 9  ; [ n,  n]
    else
      raise(SurfaceAnchorError.mk(anchor))
    end

    self.x += self.width * a[0]
    self.y += self.height * a[1]

    return self
  end

end
