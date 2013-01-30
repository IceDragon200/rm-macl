#
# src/xpan-lib/msurface3d.rb
#
module MACL::Mixin::Surface3D

  extend MACL::Mixin::Archijust

  include MACL::Mixin::Surface

  def z2
    return self.z + self.depth
  end

  def z2=(n)
    unless @freeform
      self.z = n - self.depth
    else
      self.depth = n - self.z
    end
  end

  def cz
    return self.z + self.depth / 2
  end

  def cz=(x)
    self.z = self.z - self.depth / 2
  end

end
