=begin
  chardoc/chardoc.rb
=end

begin
  require 'colorize'
rescue LoadError  
  class String
    def colorize sym
      self
    end
  end
end

require 'nokogiri'

require_relative '../src/build_tools/Chardoc.rb' 

def parze string
  str = string.dup
  str.gsub!('<c:cls>', '<span class="colorKlass">')
  str.gsub!('<c:mod>', '<span class="colorModule">')
  str.gsub!('<c:op>', '<span class="colorOperator">')
  str.gsub!('<c:func>', '<span class="colorFunction">')
  str.gsub!('<c:num>', '<span class="colorNumeric">')
  str.gsub!('<c:bool>', '<span class="colorBoolean">')
  str.gsub!('</c>', '</span>')
  str
end

def gen_funcs html, funcs
  funcs.each_pair.to_a.sort_by(&:first).each do |(name, array)|
    html.puts(%Q(
      <a name="#{name}"></a>
      <div class="methodBody">
        <h3>#{name}</h3>))
    
    array.each do |hash|
      params = (hash['params']||[]).map(&:keys).flatten
      params_s = params.join(", ")
      if n = hash['block']
        html.puts(%Q(
        <p class="methodName">#{name}<span class="colorBrak">(<span class="methodArg">#{params_s}</span>) { <span class="methodArg">#{n}</span> }</span></p>))
      else
        html.puts(%Q(
        <p class="methodName">#{name}<span class="colorBrak">(<span class="methodArg">#{params_s}</span>)</span></p>))
      end
      html.puts(%Q(
        <p>#{parze(hash['des'])}</p>))
      if params.size > 0
        html.puts(%Q(
        <div class="methodParameters">
          <h6>
            Parameters
        ))
        html.puts(hash['params'].to_a.map do |phsh|
          pname, ptype = phsh.to_a.first
          %Q(
            <span class="methodParamType">#{ptype} <span class="methodArg">#{pname}</span></span>)
        end.join(",\n"))
        html.puts(%Q(
          </h6>
        </div>))
      end  
      html.puts(%Q(
        <div class="methodParameters">
          <h6>Returns <span class="methodParamType">#{hash['return']}</span></h6>
        </div>))
    end if array
    html.puts(%Q(
      </div>))
  end
end

begin
  # //
  hash = YAML.load_file('yml/stdlibex.yml')
hash.each_pair do |klass_name, objhsh|
  next unless objhsh
  fn = case objhsh['type']
  when "module"
    ?m + klass_name
  when "class"
    ?c + klass_name
  else
    raise('Unknown class type', objhsh['type'])
  end
  puts "making #{fn}"
  html = File.open("doc/#{fn}.html", 'w+')
  html.sync = true
# // Base  
  html.puts(%Q(
<html>
  <!-- Header -->
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>#{klass_name}</title>
    <!-- Links -->
    <link rel="stylesheet" type="text/css" href="css/style.css"/>
  </head>
  <!-- Body -->
  <body>
    <!-- Class Name -->
    <div class="pageHeader">
      <h1><img src="icons/icon_gear.png" align="center">#{klass_name}</h1>
    </div>         
)) 
# // Class Methods
  if funcs = objhsh["cfuncs"]
    html.puts(%Q(
    <!-- Class Methods -->
    <div class="pageBody">
      <h2><img src="icons/icon_disc.png" align="center">Class Methods</h2>))    
    gen_funcs(html, funcs)
    html.puts(%Q(
    </div>))
  end
# // Instance Methods
  if funcs = objhsh["ifuncs"]
    html.puts(%Q(
    <!-- Instance Methods -->
    <div class="pageBody">
      <h2><img src="icons/icon_disc.png" align="center">Instance Methods</h2>))    
    gen_funcs(html, funcs)
    html.puts(%Q(
    </div>))
  end
  html.puts(%Q(  
  </body>
  <foot>
    <div class="pageFooter">
      <p>Written by IceDragon200</p>
    </div>
  </foot>  
</html>))
end

# // Catch the annoying stuff
rescue Exception => ex
  p ex
  puts ex.backtrace
end
#puts 'Press return to continue'
#gets