require 'zlib'
module SkripII
  module Reader
    include Constants
    def unpack_str str
      Zlib.inflate(str)
    end
  end
end