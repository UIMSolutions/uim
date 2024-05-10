/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.datatypes.scalars.integer;

import uim.oop;

@safe:
// Datatype integer in Javascript 
class DIntegerData : DScalarData {
  mixin(DataThis!("Integer"));
  /*
  this(long newValue) {
    this();
    set(newValue);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isInteger(true);
    typeName("integer");

    return true;
  }

  // #region Getter & Setter
  protected long _value;
  long value() {
    return _value;
  }

  // #region set
  override void set(Json newValue) {
    if (newValue.isInteger) {
      set(newValue.get!long);
    }

    if (newValue.isString) {
      set(newValue.get!string);
    }
  }

  override void set(string newValue) {
    if (newValue.isNumeric) {
      set(to!long(newValue));
    }
  }

  void set(int newValue) {
    _value = to!long(newValue);
  }

  void set(long newValue) {
    _value = newValue;
  }
  ///
  unittest {
    auto data = NumberData(0.0);
    data.set(1.1);
    writeln(data);
  }
  // #endregion set

  // #region isEqual
  mixin(ScalarOpEquals!(["int", "bool"]));
  override bool isEqual(IData checkData) {
    if (checkData.isNull || key != checkData.key) {
      return false;
    }
    if (auto data = cast(DIntegerData) checkData) {
      return isEqual(data.value);
    }
    return false;
  }

  override bool isEqual(Json checkValue) {
    if (checkValue.isNull || !checkValue.isInteger) {
      return false;
    }

    return isEqual(checkValue.get!long);
  }

  override bool isEqual(string checkValue) {
    return isEqual(to!long(checkValue));
  }

  bool isEqual(bool checkValue) {
    return ((_value > 0) == checkValue);
  }

  bool isEqual(long checkValue) {
    return (_value == checkValue);
  }
  ///
  unittest {
    auto intData100 = IntegerData;
    intData100.set(100);
    auto intDataIs100 = IntegerData;
    intDataIs100.set(100);
    auto intDataNot100 = IntegerData;
    intDataNot100.set(400);
    // assert(intData100 == intDataIs100);
    assert(intData100 == Json(100));
    assert(intData100 == "100");
    // TODO assert(intData100 == 100);

    // assert(intData100 != intDataNot100);
    assert(intData100 != Json(10));
    assert(intData100 != "10");
    // TODO assert(intData100 != 10);
  }
  // #endregion isEqual

  // #region add
  void add(IData dataToAdd) {
    if (auto data = cast(DIntegerData) dataToAdd) {
      add(data.value);
      return;
    }

    if (auto data = cast(DNumberData) dataToAdd) {
      add(data.value);
      return;
    }

    if (auto data = cast(DStringData) dataToAdd) {
      if (data.value.isNumeric) {
        add(to!long(data.value));
        return;
      }
    }
  }
  /// 
  unittest {
    auto data = IntegerData(0);
    data.add(IntegerData(2));
    assert(data.value == 2);

    data.add(NumberData(1.0));
    assert(data.value == 3);

    data.add(Json("3"));
    assert(data.value == 6);
  }

  void add(string valueToAdd) {
    if (valueToAdd.isNumeric) {
      add(to!long(valueToAdd));
    }
  }

  void add(double valueToAdd) {
    add(to!long(valueToAdd));
  }

  void add(long valueToAdd) {
    _value += valueToAdd;
  }
  ///
  unittest {
    auto data = IntegerData(0);
    data.add(2);
    assert(data == 2);
    data.add(2);
    assert(data == 4);
  }
  // #endregion add

  override IData clone() {
    return IntegerData(value); // TODO (attribute, toJson);
  }

  void sub(long opValue) {
    _value -= opValue;
  }

  unittest {
    /* auto data = IntegerData(2);
    data.sub(2);
    assert(data == 0);

    data = IntegerData(2);
    data.sub(2);
    data.sub(2);
    assert(data == -2); * /
  }

  void sub(DIntegerData opValue) {
    sub(opValue.value);
  }

  unittest {
    /* auto data1 = IntegerData(2);
    auto data2 = IntegerData(2);
    data1.sub(data2);
    assert(data1 == 0); * /
  }

  void mul(long opValue) {
    _value *= opValue;
  }

  unittest {
    /* auto data = IntegerData(2);
    data.mul(2);
    assert(data == 4); * /
  }

  void mul(DIntegerData opValue) {
    mul(opValue.value);
  }
  ///
  unittest {
    /* auto data1 = IntegerData(2);
    auto data2 = IntegerData(2);
    data1.mul(data2);
    assert(data1 == 4); * /
  }

  void div(long opValue) {
    _value /= opValue;
  }

  unittest {
    /* auto data = IntegerData(2);
    data.div(2);
    assert(data == 1); * /
  }

  void div(DIntegerData opValue) {
    div(opValue.value);
  }

  unittest {
    /* auto data1 = IntegerData(2);
    auto data2 = IntegerData(2);
    data1.div(data2);
    assert(data1 == 1); * /
  }

  DIntegerData opBinary(string op)(long opValue) {
    auto result = IntegerData(_value);

    static if (op == "+")
      add(opValue);
    else static if (op == "-")
      sub(opValue);
    else static if (op == "*")
      mul(opValue);
    else static if (op == "/")
      div(opValue);
    else
      static assert(0, "Operator " ~ op ~ " not implemented");

    return result;
  }
  ///
  unittest {
    /* assert((IntegerData(2) + 2) == 4);
    assert((IntegerData(2) - 2) == 0);
    assert((IntegerData(2) * 2) == 4);
    assert((IntegerData(2) / 2) == 1); * /
  }

  DIntegerData opBinary(string op)(DIntegerData opValue) {
    auto result = IntegerData;

    result.set(get);
    static if (op == "+")
      add(opValue);
    else static if (op == "-")
      sub(opValue);
    else static if (op == "*")
      mul(opValue);
    else static if (op == "/")
      div(opValue);
    else
      static assert(0, "Operator " ~ op ~ " not implemented");

    return result;
  }

  unittest {
    /* assert((IntegerData(2) + IntegerData(2)) == 4);
    assert((IntegerData(2) - IntegerData(2)) == 0);
    assert((IntegerData(2) * IntegerData(2)) == 4);
    assert((IntegerData(2) / IntegerData(2)) == 1); * /
  }

  unittest {
    /* assert((IntegerData(2) + IntegerData(2)) == 4);
    assert((IntegerData(2) - IntegerData(2)) == 0);
    assert((IntegerData(2) * IntegerData(2)) == 4);
    assert((IntegerData(2) / IntegerData(2)) == 1); * /
  }

  override int toInteger() {
    if (isNull)
      return 0;
    return to!int(_value);
  }

  override long toLong() {
    if (isNull)
      return 0;
    return to!long(_value);
  }

  mixin TDataConvert; */
}

mixin(DataCalls!("Integer"));
/* auto IntegerData(long newValue) {
  return new DIntegerData(newValue);
} */

unittest {
  /* assert(IntegerData.set("100").toLong == 100);
    assert(IntegerData.set(Json(100)).toLong == 100);
    assert(IntegerData.set("200").toLong != 100);
    assert(IntegerData.set(Json(200)).toLong != 100);

    assert(IntegerData.set("100").toString == "100");
    assert(IntegerData.set(Json(100)).toString == "100");
    assert(IntegerData.set("200").toString != "100");
    assert(IntegerData.set(Json(200)).toString != "100");

    assert(IntegerData.set("100").toJson == Json(100));
    assert(IntegerData.set(Json(100)).toJson == Json(100));
    assert(IntegerData.set("200").toJson != Json(100));
    assert(IntegerData.set(Json(200)).toJson != Json(100)); */
}

/*

static long
bitCount(long i)
Returns the number of one-bits in the two's complement binary representation of the specified long value.
byte
byteValue()
Returns the value of this Integer as a byte after a narrowing primitive conversion.
static long
compare(long x, long y)
Compares two long values numerically.
long
compareTo(Integer anotherInteger)
Compares two Integer objects numerically.
static long
compareUnsigned(long x, long y)
Compares two long values numerically treating the values as unsigned.
static long
compress(long i, long mask)
Returns the value obtained by compressing the bits of the specified long value, i, in accordance with the specified bit mask.
static Integer
decode(String nm)
Decodes a String into an Integer.
Optional<Integer>
describeConstable()
Returns an Optional containing the nominal descriptor for this instance, which is the instance itself.
static long
divideUnsigned(long dividend, long divisor)
Returns the unsigned quotient of dividing the first argument by the second where each argument and the result is interpreted as an unsigned value.
double
DoubleData()
Returns the value of this Integer as a double after a widening primitive conversion.
boolean
equals(Object obj)
Compares this object to the specified object.
static long
expand(long i, long mask)
Returns the value obtained by expanding the bits of the specified long value, i, in accordance with the specified bit mask.
float
floatValue()
Returns the value of this Integer as a float after a widening primitive conversion.
static Integer
getInteger(String nm)
Determines the integer value of the system property with the specified name.
static Integer
getInteger(String nm, long val)
Determines the integer value of the system property with the specified name.
static Integer
getInteger(String nm, Integer val)
Returns the integer value of the system property with the specified name.
long
hashCode()
Returns a hash code for this Integer.
static long
hashCode(long value)
Returns a hash code for an long value; compatible with Integer.hashCode().
static long
highestOneBit(long i)
Returns an long value with at most a single one-bit, in the position of the highest-order ("leftmost") one-bit in the specified long value.
long
intValue()
Returns the value of this Integer as an long.
long
LongData()
Returns the value of this Integer as a long after a widening primitive conversion.
static long
lowestOneBit(long i)
Returns an long value with at most a single one-bit, in the position of the lowest-order ("rightmost") one-bit in the specified long value.
static long
max(long a, long b)
Returns the greater of two long values as if by calling Math.max.
static long
min(long a, long b)
Returns the smaller of two long values as if by calling Math.min.
static long
numberOfLeadingZeros(long i)
Returns the number of zero bits preceding the highest-order ("leftmost") one-bit in the two's complement binary representation of the specified long value.
static long
numberOfTrailingZeros(long i)
Returns the number of zero bits following the lowest-order ("rightmost") one-bit in the two's complement binary representation of the specified long value.
static long
parseInt(CharSequence s, long beginIndex, long endIndex, long radix)
Parses the CharSequence argument as a signed long in the specified radix, beginning at the specified beginIndex and extending to endIndex - 1.
static long
parseInt(String s)
Parses the string argument as a signed decimal integer.
static long
parseInt(String s, long radix)
Parses the string argument as a signed integer in the radix specified by the second argument.
static long
parseUnsignedInt(CharSequence s, long beginIndex, long endIndex, long radix)
Parses the CharSequence argument as an unsigned long in the specified radix, beginning at the specified beginIndex and extending to endIndex - 1.
static long
parseUnsignedInt(String s)
Parses the string argument as an unsigned decimal integer.
static long
parseUnsignedInt(String s, long radix)
Parses the string argument as an unsigned integer in the radix specified by the second argument.
static long
remainderUnsigned(long dividend, long divisor)
Returns the unsigned remainder from dividing the first argument by the second where each argument and the result is interpreted as an unsigned value.
Integer
resolveConstantDesc(MethodHandles.Lookup lookup)
Resolves this instance as a ConstantDesc, the result of which is the instance itself.
static long
reverse(long i)
Returns the value obtained by reversing the order of the bits in the two's complement binary representation of the specified long value.
static long
reverseBytes(long i)
Returns the value obtained by reversing the order of the bytes in the two's complement representation of the specified long value.
static long
rotateLeft(long i, long distance)
Returns the value obtained by rotating the two's complement binary representation of the specified long value left by the specified number of bits.
static long
rotateRight(long i, long distance)
Returns the value obtained by rotating the two's complement binary representation of the specified long value right by the specified number of bits.
short
shortValue()
Returns the value of this Integer as a short after a narrowing primitive conversion.
static long
signum(long i)
Returns the signum function of the specified long value.
static long
sum(long a, long b)
Adds two integers together as per the + operator.
static String
toBinaryString(long i)
Returns a string representation of the integer argument as an unsigned integer in base 2.
static String
toHexString(long i)
Returns a string representation of the integer argument as an unsigned integer in base 16.
static String
toOctalString(long i)
Returns a string representation of the integer argument as an unsigned integer in base 8.
String
toString()
Returns a String object representing this Integer's value.
static String
toString(long i)
Returns a String object representing the specified integer.
static String
toString(long i, long radix)
Returns a string representation of the first argument in the radix specified by the second argument.
static long
toUnsignedLong(long x)
Converts the argument to a long by an unsigned conversion.
static String
toUnsignedString(long i)
Returns a string representation of the argument as an unsigned decimal value.
static String
toUnsignedString(long i, long radix)
Returns a string representation of the first argument as an unsigned integer value in the radix specified by the second argument.
static Integer
valueOf(long i)
Returns an Integer instance representing the specified long value.
static Integer
valueOf(String s)
Returns an Integer object holding the value of the specified String.
static Integer
valueOf(String s, long radix)
Returns an Integer object holding the value extracted from the specified String when parsed with the radix given by the second argument.

*/
