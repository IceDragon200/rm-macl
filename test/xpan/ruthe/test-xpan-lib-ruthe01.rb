require_relative 'common.rb'

mod1 = MACL::Ruthe.import("data/test_ruthe_module.rb", Module)
mod2 = MACL::Ruthe.import("data/test_ruthe_module.rb", Module)
mod3 = MACL::Ruthe.import("data/test_ruthe_module.rb", Module)
mod1.hello_world
mod2.hello_world
mod3.hello_world