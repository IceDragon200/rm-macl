## Change Log
### V3.0.0 [16/09/2013]
  Directory Structure has been changed to gem style.
  A .gemspec has been created to allow the gemfication of the lib.
  This is the final version of the lib, no further changes will be made.
  In short, the RGSS3 MACL is now discontinued.

### V2.3.1 [24/07/2013]
  ADDED
    Ruthe: a import module similar to Lua's require, though it still requires
    a bit of back work to get working correctly.

### V2.3.0 [19/06/2013]
  CHANGE
    Surface::ANCHOR_* have changed slightly
      ANCHOR_CENTER refers not to the absolute center of a surface, but
      the Horizontal center position, use ANCHOR_MIDDLE_CENTER instead

### V2.2.4 [16/05/2013]
```
  CHANGE
    VERSION is now just 3 numbers, the last 3 seemed too extra

  FIXED
    gm-classes.rb
    gm-modules.rb
      Both where reloading the mixin/ source files instead of their respective
      gm-classes/ and gm-modules/

  MOVED
    lib/xpan-lib/archijust.rb > lib/mixin/archijust.rb
      Always wondered why I didn't move it to the mixins instead of the
      Xpansion Lib
```

### V2.2.3.000 [11/05/2013]
```
  ADDED
    MACL::Mixin::Surface#anchor_*
    MACL::Mixin::Surface#set_anchor_*

  CHANGE
    MACL::Mixin::Surface#reanchor
      Now uses the anchor_* methods for calculation and setting

```

### V2.2.2.000 [05/05/2013]
```
  ADDED
    MACL::Pos2

```

### V2.2.1.000 [04/05/2013]
```
  ADDED
    MACL::Mixin::Archijust::uint_reader
    MACL::Mixin::Archijust::uint_writer
    MACL::Mixin::Archijust::uint_accessor
      Forces Incoming and Outgoing values to be greater than 0
```

### V2.2.0.000 [05/04/2013]
```
  ADDED
    MACL::Mixin::StackElement [lib/mixin/stackelement.rb]

```
### V2.1.5.000 [04/04/2013]
```
  CHANGE
    MACL::Vector* can now do math funcs with Arrays of the same size

```
### V2.1.4.000 [02/04/2013]
```
  BUGFIX
    MACL::Pos3

```
### V2.1.3.000 [01/04/2013]
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
### V2.1.2.000 [30/03/2013]
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

### V2.1.1.000 [29/03/2013]
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

### V2.1.0.000 [25/03/2013]
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

### V2.0.3.002 [24/03/2013]
```
  ADDED
    MACL::VectorList
      VectorList is a shorthand of the MACL::Matrix, utilizing only 1 dimension

  CHANGE
    Point* is now a subclass of Vector*i rather than an alias
```

### V2.0.3.001 [23/03/2013]
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

### V2.0.3.000 [22/03/2013]
```
  Renamed Numeric#unary > Numeric#signum
  Renamed Numeric#unary_inv > Numeric#signum_inv
```

### V2.0.2.001 [16/03/2013]
  Added Numeric#wall
  Added Archijust#bool_*

### V2.0.1.000 [??/03/2013]
```
  Added (lib/mixin/color-math.rb) MACL::Mixin::ColorMath
```

### V2.0.0.000