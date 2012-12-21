module MACL::Mixin::Surface

  class SurfaceError < StandardError
  end

  class SurfaceAnchorError < SurfaceError

    def self.mk(anchor)
      new("Invalid Surface Anchor #{anchor}")
    end

  end

end
