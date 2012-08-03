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
require_relative '../src/standardlibex/Hash_Ex.rb' 

AUTO_COLOR = {
  ['unless', 'if', 'then', 'loop', 'do', 'while', 'until', 'for', 'begin', 'end', 
   'return', 'self', 'break', 'class', 'module', 'require', 'include', 'extend',
   'define_method', 'alias', 'public', 'private', 'block'] => 'core',
  ['Class', 'Module', 'String', 'Object', 'Numeric', 'Integer', 'Float', 'Bignum', 'Boolean', 'Array', 'Hash', 'MatchData'] => 'cls',
  ['Marshal', 'Kernel', 'Enumerable'] => 'mod',
  ['true', 'false', 'TRUE', 'FALSE', 'nil'] => 'bool',
  ['+', '-', '*', '/', "\\", '<=>', '>', '<', '!!', '&', '|', '?'] => 'op',
  ['each'] => 'func',
  #:number => 'num', # // Special Rule
  #[:ivar, :gvar] => 'var',
}

AUTO_COLOR.enum2keys!

AUTO_COLOR.replace(AUTO_COLOR.each_with_object({}) do |(k, v), r|
  r[k] = "<c:#{v}>#{k}</c>"
end)

def auto_color str, special_list={}
  result = str.dup
  # // Hex
  result.gsub!(/(#\w+)/) do wrap_in_ctag($1, 'num') end
  # // Float
  result.gsub!(/(\d+.\d+)/) do wrap_in_ctag($1, 'num') end
  # // Integer
  result.gsub!(/(\d+)/) do wrap_in_ctag($1, 'num') end
  # // Instance and Global Variable
  result.gsub!(/([@$]\w+)/) do wrap_in_ctag($1, 'var') end
  # // Functions
  result.gsub!(/#(\S+)/) do wrap_in_ctag($1, 'func') end    
  # // Everything else  
  result.gsub!(/(\w+|\S+)/) do AUTO_COLOR[$1]||special_list[$1] || $1 end

  #puts result

  result
end

def wrap_in_ctag str, tag
  "<c:#{tag}>#{str}</c>"
end

def parze string
  str = string.dup
  str.gsub!('<c:cls>' , '<span class="colorKlass">')
  str.gsub!('<c:mod>' , '<span class="colorModule">')
  str.gsub!('<c:op>'  , '<span class="colorOperator">')
  str.gsub!('<c:func>', '<span class="colorFunction">')
  str.gsub!('<c:num>' , '<span class="colorNumeric">')
  str.gsub!('<c:bool>', '<span class="colorBoolean">')
  str.gsub!('<c:arg>' , '<span class="colorArg">')
  str.gsub!('<c:var>' , '<span class="colorVariable">')
  str.gsub!('<c:core>', '<span class="colorCore">')
  str.gsub!('</c>', '</span>')
  str
end

def gen_funcs html, funcs
  funcs.to_a.sort_by(&:first).each do |(name, array)|
    html.puts(%Q(
      <a name="#{name}"></a>
      <div class="methodBody">
        <h2>#{name}</h2>))
    
    array.each do |hash|
      hash ||= {}
      params = (hash['params']||[]).map(&:keys).flatten
      params_s = params.join(", ")
      if n = hash['block']
        html.puts(%Q(
        <p class="methodName">#{name}<span class="colorBrak">(<span class="methodArg">#{params_s}</span>) { <span class="methodArg">#{n}</span> }</span></p>))
      else
        html.puts(%Q(
        <p class="methodName">#{name}<span class="colorBrak">(<span class="methodArg">#{params_s}</span>)</span></p>))
      end
      # // Description
      special_list = {}
      params.each do |p| special_list[p] = wrap_in_ctag(p, 'arg') end
      description = parze(auto_color(hash['des'].to_s, special_list))
      html.puts(%Q(
        <p>#{description}</p>))
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
        </div>)) if hash['return']
    end if array
    html.puts(%Q(
      </div>))
  end
end

begin
  # //
  stubs = {
    'class'  => [],
    'module' => []
  }
  hash = YAML.load_file('yml/stdlibex.yml')
hash.each_pair do |klass_name, objhsh|
  next unless objhsh
  case objhsh['type']
  when "module"
    icon_name = 'icon_box'
    fn = ?m + klass_name
  when "class"
    icon_name = 'icon_gear'
    fn = ?c + klass_name
  else
    raise('Unknown class type', objhsh['type'])
  end
  sifuncs = (objhsh['ifuncs']||{}).keys.sort
  sifuncs.map! do |meth| %Q(<a href="#{fn}.html##{meth}">##{meth}</a>) end
  scfuncs = (objhsh['cfuncs']||{}).keys.sort
  scfuncs.map! do |meth| %Q(<a href="#{fn}.html##{meth}">#{klass_name}#{meth}</a>) end  
  sconsts = (objhsh['consts']||{}).keys.sort
  sconsts.map! do |n| %Q(<a href="#{fn}.html##{n}">#{n}</a>) end  
  kstub = nil
File.open('stub/%s.html' % klass_name, ?w) do |f| 
  str = %Q( 
      <a name="#{fn}"></a>
      <div class="klassBody">
        <p class="klassLink"><a href="#{fn}.html">#{klass_name}</a></p>
        <p class="klassStats">
          Constants: #{sconsts.join(' ')}
        </p>  
        <p class="klassStats">  
          Class Methods: #{scfuncs.join(' ')}
        </p>    
        <p class="klassStats">  
          Instance Methods: #{sifuncs.join(' ')}
        </p>  
        <p class="klassStats">  
          Source: #{objhsh['source']}
        </p>
      </div>
    )
  f.puts str 
  kstub = [klass_name, str]
  stubs[objhsh['type']] << kstub
end  
  puts "making #{fn}"
  html = File.open("doc/#{fn}.html", 'w+')
  html.sync = true
# // Base  
  home_button = %Q(<h2><a href="index.html">Home</a> <a href="index.html##{fn}">Return</a></h2>)
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
      #{home_button}
      <h1><img src="icons/#{icon_name}.png" align="center">#{klass_name}</h1>
    </div>
    <div class="pageBody">
      <p>#{objhsh['des']}</p>
      <p>#{kstub[1]}<p>
    </div>))         
# // Constants
  if konsts = objhsh["consts"]
    html.puts(%Q(
    <!-- Constants -->
    <div class="pageBody">
      <h2><img src="icons/icon_book-brown.png" align="center">Constants</h2>
      <a name="Consts"></a>))
    konsts.to_a.sort_by(&:first).each do |(konst, konst_hsh)|
      description = parze(auto_color(konst_hsh['des']))
      html.puts(%Q(
      <div class="methodBody">     
        <div class="methodParameters"><h6><span class="methodParamType">#{konst_hsh['type']} <span class="methodArg">#{konst}</span></span></h6></div>
        <p>#{description}</p>
      </div>))
    end  
    html.puts(%Q(
    </div>))
  end
# // Class Variables
  if funcs = objhsh["clsvars"]
    html.puts(%Q(
    <!-- Class Variables -->
    <div class="pageBody">
      <h2><img src="icons/icon_book-brown.png" align="center">Class Variables</h2>))    
    #
    html.puts(%Q(
    </div>))
  end
# // Class Instance Variables
  if funcs = objhsh["clsivars"]
    html.puts(%Q(
    <!-- Class Instance Variables -->
    <div class="pageBody">
      <h2><img src="icons/icon_book-brown.png" align="center">Class Instance Variables</h2>))    
    #
    html.puts(%Q(
    </div>))
  end
# // Attributes
  if funcs = objhsh["iattrs"]
    html.puts(%Q(
    <!-- Attributes -->
    <div class="pageBody">
      <h2><img src="icons/icon_disc.png" align="center">Instance Attributes</h2>))    
    #
    html.puts(%Q(
    </div>))
  end  
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
      #{home_button}
      <p>Generated by Chardoc, Written by IceDragon200</p>
    </div>
  </foot>  
</html>))
end
klasses = stubs['class'].sort_by(&:first)
modules = stubs['module'].sort_by(&:first)
# // index.html
File.open('doc/index.html', ?w) do |f| 
f.puts %Q(
<html>
  <!-- Head -->
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>RGSS3-MACL API Reference</title>
    <!-- Links -->
    <link rel="stylesheet" type="text/css" href="css/style.css"/>  
  </head>
  <!-- Body -->
  <body>
    <div class="pageHeader">
      <h1>RGSS3-MACL API Reference</h1>
    </div>
    <div class="pageBody">
      <h2><img src="icons/icon_gear.png" align="center">Classes</h2>
      #{klasses.map(&:last).join("\n")}
    </div>  
    <div class="pageBody">
      <h2><img src="icons/icon_box.png" align="center">Modules</h2>
      #{modules.map(&:last).join("\n")}
    </div>
  </body>
  <foot>
    <div class="pageFooter">
      <p>Written by IceDragon200</p>
    </div>
  </foot>
</html>)
end
# // Catch the annoying stuff
rescue Exception => ex
  p ex
  puts ex.backtrace
end
#puts 'Press return to continue'
#gets