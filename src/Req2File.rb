# // Extract require 2 file
# // 04/14/2012
# // 04/14/2012
module Req2File
  class << self
    def import_require(file)
      r = file.read
      striped = []
      r.gsub!(/require\(?[ ]*[\"\'](.*)[\"\']\)?/i) { striped << $1;File.open($1+".rb").read }
      return [r, striped]
    end
  end  
end
