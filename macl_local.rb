path = File.dirname(__FILE__)+'/src/**/*_local_require.rb'
$macl_load_requests ||= ['std', 'macl', 'core', 'xpan', 'vxa-mod', 'vxa-cls', 'rpg', 'rgssx2']
Dir[path].sort.each do |s|
  require_relative '%s' % s
  puts "Loaded: %s" % s
end
#require_relative 'src/standardlibex/_local_require'
#require_relative 'src/macl/_local_require'
#require_relative 'src/xpanlib/_local_require'
#require_relative 'src/rgssex/_local_require'