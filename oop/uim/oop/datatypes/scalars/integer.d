/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.datatypes.scalars.integer;

import uim.oop;

@safe:
class DIntegerData : DScalarData {
  mixin(DataThis!("Integer"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isInteger(true);

    return true;
  }

  // #region Getter & Setter
  int get() {
    return _value;
  }

  void set(int newValue) {
    _value = newValue;
  }

  mixin(DataGetSetTemplate!("0", "int"));
  // #endregion Getter & Setter

  // #region equal
    mixin(ScalarDataOpEquals!("int"));

    override bool isEqual(IData[string] checkData) {
      return false;
    }

    override bool isEqual(IData checkData) {
      if (checkData.isNull || key != checkData.key) {
        return false;
      }
      if (auto intData = cast(DIntegerData) checkData) {
        return (get == intData.get);
      }
      return false;
    }

    override bool isEqual(Json checkValue) {
      if (checkValue.isNull || !checkValue.isInt) {
        return false;
      }

      return (get == checkValue.get!int);
    }

    override bool isEqual(string checkValue) {
      return (get == to!int(checkValue));
    }

    bool isEqual(int checkValue) {
      return (get == checkValue);
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
      assert(intData100 == 100);

      // assert(intData100 != intDataNot100);
      assert(intData100 != Json(10));
      assert(intData100 != "10");
      assert(intData100 != 10);
    }
  // #endregion equal

  unittest {
    /* auto data = IntegerData;
    data(100); */
  }

  void add(int opValue) {
    _value += opValue;
  }

  unittest {
    /* auto value = IntegerData(0);
    value.add(2);
    assert(value == 2);
    value.add(2);
    assert(value == 4); */
  }

  void add(DIntegerData opValue) {
    _value += opValue.get;
  }

  override IData clone() {
    return IntegerData; // TODO (attribute, toJson);
  }

  void sub(int opValue) {
    _value -= opValue;
  }

  unittest {
    /* auto data = IntegerData(2);
    data.sub(2);
    assert(data == 0);

    data = IntegerData(2);
    data.sub(2);
    data.sub(2);
    assert(data == -2); */
  }

  void sub(DIntegerData opValue) {
    _value -= opValue.get;
  }

  unittest {
    /* auto data1 = IntegerData(2);
    auto data2 = IntegerData(2);
    data1.sub(data2);
    assert(data1 == 0); */
  }

  void mul(int opValue) {
    _value *= opValue;
  }

  unittest {
    /* auto data = IntegerData(2);
    data.mul(2);
    assert(data == 4); */
  }

  void mul(DIntegerData opValue) {
    _value *= opValue.get;
  }
  ///
  unittest {
    /* auto data1 = IntegerData(2);
    auto data2 = IntegerData(2);
    data1.mul(data2);
    assert(data1 == 4); */
  }

  void div(int opValue) {
    _value /= opValue;
  }

  unittest {
    /* auto data = IntegerData(2);
    data.div(2);
    assert(data == 1); */
  }

  void div(DIntegerData opValue) {
    _value /= opValue.get;
  }

  unittest {
    /* auto data1 = IntegerData(2);
    auto data2 = IntegerData(2);
    data1.div(data2);
    assert(data1 == 1); */
  }

  DIntegerData opBinary(string op)(int opValue) {
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
    assert((IntegerData(2) / 2) == 1); */
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
    assert((IntegerData(2) / IntegerData(2)) == 1); */
  }

  unittest {
    /* assert((IntegerData(2) + IntegerData(2)) == 4);
    assert((IntegerData(2) - IntegerData(2)) == 0);
    assert((IntegerData(2) * IntegerData(2)) == 4);
    assert((IntegerData(2) / IntegerData(2)) == 1); */
  }

  long toLong() {
    if (isNull)
      return 0;
    return to!long(_value);
  }

  mixin DataConvertTemplate;
}

mixin(DataCalls!("Integer"));

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

static int
bitCount(int i)
Returns the number of one-bits in the two's complement binary representation of the specified int value.
byte
byteValue()
Returns the value of this Integer as a byte after a narrowing primitive conversion.
static int
compare(int x, int y)
Compares two int values numerically.
int
compareTo(Integer anotherInteger)
Compares two Integer objects numerically.
static int
compareUnsigned(int x, int y)
Compares two int values numerically treating the values as unsigned.
static int
compress(int i, int mask)
Returns the value obtained by compressing the bits of the specified int value, i, in accordance with the specified bit mask.
static Integer
decode(String nm)
Decodes a String into an Integer.
Optional<Integer>
describeConstable()
Returns an Optional containing the nominal descriptor for this instance, which is the instance itself.
static int
divideUnsigned(int dividend, int divisor)
Returns the unsigned quotient of dividing the first argument by the second where each argument and the result is interpreted as an unsigned value.
double
DoubleData()
Returns the value of this Integer as a double after a widening primitive conversion.
boolean
equals(Object obj)
Compares this object to the specified object.
static int
expand(int i, int mask)
Returns the value obtained by expanding the bits of the specified int value, i, in accordance with the specified bit mask.
float
floatValue()
Returns the value of this Integer as a float after a widening primitive conversion.
static Integer
getInteger(String nm)
Determines the integer value of the system property with the specified name.
static Integer
getInteger(String nm, int val)
Determines the integer value of the system property with the specified name.
static Integer
getInteger(String nm, Integer val)
Returns the integer value of the system property with the specified name.
int
hashCode()
Returns a hash code for this Integer.
static int
hashCode(int value)
Returns a hash code for an int value; compatible with Integer.hashCode().
static int
highestOneBit(int i)
Returns an int value with at most a single one-bit, in the position of the highest-order ("leftmost") one-bit in the specified int value.
int
intValue()
Returns the value of this Integer as an int.
long
LongData()
Returns the value of this Integer as a long after a widening primitive conversion.
static int
lowestOneBit(int i)
Returns an int value with at most a single one-bit, in the position of the lowest-order ("rightmost") one-bit in the specified int value.
static int
max(int a, int b)
Returns the greater of two int values as if by calling Math.max.
static int
min(int a, int b)
Returns the smaller of two int values as if by calling Math.min.
static int
numberOfLeadingZeros(int i)
Returns the number of zero bits preceding the highest-order ("leftmost") one-bit in the two's complement binary representation of the specified int value.
static int
numberOfTrailingZeros(int i)
Returns the number of zero bits following the lowest-order ("rightmost") one-bit in the two's complement binary representation of the specified int value.
static int
parseInt(CharSequence s, int beginIndex, int endIndex, int radix)
Parses the CharSequence argument as a signed int in the specified radix, beginning at the specified beginIndex and extending to endIndex - 1.
static int
parseInt(String s)
Parses the string argument as a signed decimal integer.
static int
parseInt(String s, int radix)
Parses the string argument as a signed integer in the radix specified by the second argument.
static int
parseUnsignedInt(CharSequence s, int beginIndex, int endIndex, int radix)
Parses the CharSequence argument as an unsigned int in the specified radix, beginning at the specified beginIndex and extending to endIndex - 1.
static int
parseUnsignedInt(String s)
Parses the string argument as an unsigned decimal integer.
static int
parseUnsignedInt(String s, int radix)
Parses the string argument as an unsigned integer in the radix specified by the second argument.
static int
remainderUnsigned(int dividend, int divisor)
Returns the unsigned remainder from dividing the first argument by the second where each argument and the result is interpreted as an unsigned value.
Integer
resolveConstantDesc(MethodHandles.Lookup lookup)
Resolves this instance as a ConstantDesc, the result of which is the instance itself.
static int
reverse(int i)
Returns the value obtained by reversing the order of the bits in the two's complement binary representation of the specified int value.
static int
reverseBytes(int i)
Returns the value obtained by reversing the order of the bytes in the two's complement representation of the specified int value.
static int
rotateLeft(int i, int distance)
Returns the value obtained by rotating the two's complement binary representation of the specified int value left by the specified number of bits.
static int
rotateRight(int i, int distance)
Returns the value obtained by rotating the two's complement binary representation of the specified int value right by the specified number of bits.
short
shortValue()
Returns the value of this Integer as a short after a narrowing primitive conversion.
static int
signum(int i)
Returns the signum function of the specified int value.
static int
sum(int a, int b)
Adds two integers together as per the + operator.
static String
toBinaryString(int i)
Returns a string representation of the integer argument as an unsigned integer in base 2.
static String
toHexString(int i)
Returns a string representation of the integer argument as an unsigned integer in base 16.
static String
toOctalString(int i)
Returns a string representation of the integer argument as an unsigned integer in base 8.
String
toString()
Returns a String object representing this Integer's value.
static String
toString(int i)
Returns a String object representing the specified integer.
static String
toString(int i, int radix)
Returns a string representation of the first argument in the radix specified by the second argument.
static long
toUnsignedLong(int x)
Converts the argument to a long by an unsigned conversion.
static String
toUnsignedString(int i)
Returns a string representation of the argument as an unsigned decimal value.
static String
toUnsignedString(int i, int radix)
Returns a string representation of the first argument as an unsigned integer value in the radix specified by the second argument.
static Integer
valueOf(int i)
Returns an Integer instance representing the specified int value.
static Integer
valueOf(String s)
Returns an Integer object holding the value of the specified String.
static Integer
valueOf(String s, int radix)
Returns an Integer object holding the value extracted from the specified String when parsed with the radix given by the second argument.

*/
