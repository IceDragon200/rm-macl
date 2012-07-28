module SkripII
  module Reader
    def unpack_str str
      Zlib.inflate(str)
    end
  end
end