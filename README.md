RGSS3-MACL
==========
## vr 2.0.3.001 [![Code Climate](https://codeclimate.com/github/IceDragon200/RGSS3-MACL.png)](https://codeclimate.com/github/IceDragon200/RGSS3-MACL)

## Introduction
Spanning many years, coming from the RM community, this library contains
classes and methods, that pop up, time and time again in development.

## TODO
```
Tests need to be rewritten
lib/xpan-lib/geometry has several incomplete classes
```

## Test
Tests need to be rewritten for the current version (2.0.0), since all tests
where broken in (1.6.0)

## Credits
For all those who had contributed to the development of the MACL as well as
debugging, and suggestions for impovement.

```
CaptainJet
FenixFyreX
PK8
```

## Change Log
### vr 2.0.3.001
  ADDED
    CallbackError to MACL::Mixin::Callback
    MACL::Mixin::Callback::log
      Set this to any IO object, and all output will be routed.
      You can set individual logs by using the instances @callback_log or
      #callback_log=
    Vector*#normalize, Vector*#normalize!, Vector*#magnitude=
      #normalize will function properly only with 2 dimensional vectors
      currently

  RENAME
    Vector#degrees* to Vector#angle*
    Vector::from_polar to Vector::polar

  BUGFIX
    Interpolate#bezier now uses Vector2f instead of Vector2i

### vr 2.0.3.000
  Renamed Numeric#unary > Numeric#signum
  Renamed Numeric#unary_inv > Numeric#signum_inv

### vr 2.0.2.001
  Added Numeric#wall
  Added Archijust#bool_*

### vr 2.0.1.000
  Added (lib/mixin/color-math.rb) MACL::Mixin::ColorMath

### vr 2.0.0.000
I'll eventually write this
