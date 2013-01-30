module MACL::Mixin::Surface3D

  def as_s3a
    return self.x, self.y, self.z, self.x2, self.y2, self.z2
  end

  def as_surface3d
    MACL::Surface3D.new(self.x, self.y, self.z, self.x2, self.y2, self.z2)
  end

end
