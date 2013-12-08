$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'test/unit'
require 'pp'
require 'rm-macl/fallback'
require 'rm-macl'
#pp MACL.registered