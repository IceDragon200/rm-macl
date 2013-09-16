lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rm-macl/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "rm-macl"
  s.summary     = "Extensions for RMVXA and RGSS3"
  s.description = %q(A method and class library for extending RPG Maker VXA and RGSS3)
  s.date        = %q(2013-09-16)
  s.version     = MACL::VERSION
  s.homepage    = %q{https://github.com/IceDragon200/rm-macl}
  s.license     = 'MIT'

  s.author = "Corey Powell"
  s.email  = %q{mistdragon100@gmail.com}

  s.add_bindir("bin")
  s.files = ["Rakefile", "LICENSE", "README.md"]
  s.files.concat(Dir.glob("lib/**/*"))
  s.files.concat(Dir.glob("test/**/*"))
  s.test_file = 'test/test-suite.rb'
  s.require_path = "lib"
end