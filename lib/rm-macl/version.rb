#
# rm-macl/lib/rm-macl/version.rb
#
module MACL
  module Version
    MAJOR = 3
    MINOR = 3
    PATCH = 0
    BUILD = nil
    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join(".").freeze
  end

  ##
  # current version of the rm-macl
  VERSION = Version::STRING

end