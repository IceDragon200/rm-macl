RGSS3-MACL
==========
## vr 2.2.1.000 [![Code Climate](https://codeclimate.com/github/IceDragon200/RGSS3-MACL.png)](https://codeclimate.com/github/IceDragon200/RGSS3-MACL)

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

### vr 2.2.1.000 [04/05/2013]
```
  ADDED
    MACL::Mixin::StackElement::uint_reader
    MACL::Mixin::StackElement::uint_writer
    MACL::Mixin::StackElement::uint_accessor
      Forces Incoming and Outgoing values to be greater than 0
```

### vr 2.2.0.000 [05/04/2013]
```
  ADDED
    MACL::Mixin::StackElement [lib/mixin/stackelement.rb]

```
### vr 2.1.5.000 [04/04/2013]
```
  CHANGE
    MACL::Vector* can now do math funcs with Arrays of the same size

```
### vr 2.1.4.000 [02/04/2013]
```
  BUGFIX
    MACL::Pos3

```
### vr 2.1.3.000 [01/04/2013]
```
  ADDED
    MACL::MatrixBase#to_a
    MACL::MatrixBase#hash
    MACL::MatrixBase#hash

  CHANGE
    MACL::MatrixBase is now Comparable, however this may be slow with large
    matrices

  REWRITE
    MACL::Vector*

  BUGFIX
    MACL::Vector*
      would StackError if compared, this has been fixed by implementing the #<=> method

    MACL::VectorList
      Was bricked due to missing arguments for super call

```
### vr 2.1.2.000 [30/03/2013]
```
  ADDED
    MACL::Grid3

  CHANGE
    MACL::Grid > MACL::Grid2

  ALIAS
    MACL::Grid2 as MACL::Grid

  UPDATE
    MACL::Grid2 [1.0.0]

  BUGFIX
    MACL::Cube#to_s
      to_s now uses the to_h instead of the missing to_hash method
```

### vr 2.1.1.000 [29/03/2013]
```
  ADDED
    MACL::MatrixBase#size alias of MACL::MatrixBase#datasize
    MACL::frame_rate
    MACL::Tween2
      Been longing to do a clean rewrite of Tween, and Tween2 solves that issue,
      its mostly an cosmetic change from the original, the code is much cleaner,
      and the usage is slighly different.

  CHANGE
    MACL::MatrixBase
      Parent class for Matrix

    MACL::Matrix extends MACL::MatrixBase
      Meta programming has been removed.

  FIXES
    Fixed FloatDomainError when using MACL::Easer::Back::InOut
```

### vr 2.1.0.000 [25/03/2013]
```
  MOVED
    MACL::Tween::Easer to MACL::Easer

  REWRITE
    MACL::Easer
      Easer has now been broken into smaller seperate files for easy management,
      and isolation.
      Easers are now seperate classes which can have instances with different
      properties with the same easing.
      This was done to allow configuration of Easers such as Elastic and Back
```

### vr 2.0.3.002 [24/03/2013]
```
  ADDED
    MACL::VectorList
      VectorList is a shorthand of the MACL::Matrix, utilizing only 1 dimension

  CHANGE
    Point* is now a subclass of Vector*i rather than an alias
```

### vr 2.0.3.001 [23/03/2013]
```
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
    Vector*I to Vector*i
    Vector*F to Vector*f

  BUGFIX
    Interpolate#bezier now uses Vector2f instead of Vector2i
```

### vr 2.0.3.000 [22/03/2013]
```
  Renamed Numeric#unary > Numeric#signum
  Renamed Numeric#unary_inv > Numeric#signum_inv
```

### vr 2.0.2.001 [16/03/2013]
  Added Numeric#wall
  Added Archijust#bool_*

### vr 2.0.1.000 [??/03/2013]
```
  Added (lib/mixin/color-math.rb) MACL::Mixin::ColorMath
```

### vr 2.0.0.000
