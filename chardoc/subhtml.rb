=begin
  Sublime theme to html
=end
require_relative '../src/standardlibex/String_Ex.rb'
require 'nokogiri'

begin
  input_filename  = 'monokai.xml'
  name = File.basename(input_filename, File.extname(input_filename))
  output_filename = name + '.html'
  file = File.open(input_filename, ?r)
  #xml = Nokogiri.XML(file)
  str = file.read
  html = File.open(output_filename, ?w)
  html.sync = true

  colors = str.scan(/(\#\w{6})/i).map(&:first).uniq
  #p colors
  # // Writing
  html.puts '<html>'
  html.puts '<head>'.indent(2)
  html.puts "<title>#{name} Theme</title>".indent(4)
  html.puts %Q(<style type="text/css">body{background-color: #242424;margin: 4%;padding: 4px;font-family: 'Gudea', sans-serif;;}</style>)
  html.puts '</head>'.indent(2)
  html.puts '<body>'
  colors.each do |hex|
    hexsegs = hex[1,6]
    hexsegs = hexsegs.split(/(\w{2})/).reject(&:empty?)
    #puts hexsegs
    hex2 = ?# + hexsegs.map { |i| "%02x" % (i.hex * 0.5).to_i }.join('')
    hex3 = ?# + hexsegs.map { |i| "%02x" % (255 - i.hex).to_i }.join('')
    #puts hex2
    html.puts %Q(<span style="color: #{hex3};background-color: #{hex};border: thin solid #{hex2};border-radius: 4px;width: 256px;height: 32px";text-align: center;margin: 4%;padding: 4%;>#{hex}</span>)
  end
  html.puts '</body>'
  html.puts '</html>'
  puts 'Job Complete'
rescue Exception => ex
  p ex
  puts ex.backtrace
end
#puts 'Press return to continue'
#gets