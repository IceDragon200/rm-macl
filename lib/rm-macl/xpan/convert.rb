#
# rm-macl/lib/rm-macl/xpan/convert.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/core_ext/array'
require 'rm-macl/core_ext/kernel'
require 'rm-macl/core_ext/module'
require 'rm-macl/xpan/type-stub'

module MACL
  module Convert

    def extract_args(*args)
      return args.size > 1 ? args : args.first
    end

    def Vector2(*args)
      MACL::Vector2.tcast(extract_args(*args))
    end

    def Vector3(*args)
      MACL::Vector3.tcast(extract_args(*args))
    end

    def Vector4(*args)
      MACL::Vector4.tcast(extract_args(*args))
    end

    def Rect(*args)
      Rect.tcast(extract_args(*args))
    end

    def Cube(*args)
      MACL::Cube.tcast(extract_args(*args))
    end

    def Anchor(*args)
      MACL::Surface::Anchor.tcast(extract_args(*args))
    end

    def Color(*args)
      Color.tcast(extract_args(*args))
    end

    def Tone(*args)
      Tone.tcast(extract_args(*args))
    end

    def Surface2(*args)
      MACL::Surface2.tcast(extract_args(*args))
    end

    def Surface3(*args)
      MACL::Surface3.tcast(extract_args(*args))
    end

    def Easer(arg)
      case arg
      when Symbol      then MACL::Easer.get_easer(arg)
      when MACL::Easer then arg
      when Class       then arg.easer
      else                  raise TypeError, "wrong argument type #{arg.class} (expected Symbol or MACL::Easer)"
      end
    end

    def ToneArray3(obj)
      case obj
      when Numeric then [obj, obj, obj]
      when Color   then [obj.red, obj.green, obj.blue]
      when Tone    then [obj.red, obj.green, obj.blue]
      when Array   then obj.pad(3, 0)
      else
        raise TypeError,
              "wrong argument type (#{obj.class}) expected Numeric, Color, Tone, or Array"
      end
    end

    def ColorArray4(obj)
      case obj
      when Numeric then [obj, obj, obj, 255]
      when Color   then [obj.red, obj.green, obj.blue, obj.alpha]
      when Tone    then [obj.red, obj.green, obj.blue, obj.gray]
      when Array   then obj.pad(4, 255)
      else
        raise TypeError,
              "wrong argument type (#{obj.class}) expected Numeric, Color, Tone, or Array"
      end
    end

    private :extract_args

    extend self

  end
end
MACL.register('macl/xpan/convert', '1.1.0') if defined?(MACL.register)