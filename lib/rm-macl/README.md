RGSS3-MACL Lib
==============
# Data Types
## Primary
```
  Boolean
  Integer
  String
  Float
```

## Composite Types
```
  Array<Content_DataType>
  Hash<Key_DataType, Value_DataType>
```

## Abstract Types
```
  Rate (Float)
    Expected to be of Type Float and in a Range of 0..1
```

## Symbols
```
  (Datatype)*
    Expected to be a #kind_of?((Datatype))
  ...(Datatype)
    Equivalent to Ruby *args on a function
```
