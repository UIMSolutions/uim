/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.values.scalars.integer;

import uim.models;

@safe:
class DIntegerData: DData {
  mixin(DataThis!("IntegerValue", "int"));  

  protected int _value;  
  alias value = DData.value;
  O value(this O)(int newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  int value() {
    return _value; 
  }
  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .isInteger(true);
  }

  // Hooks for setting 
  protected void set(int newValue) {
    _value = newValue; 
  }  

  override protected void set(string newValue) {
    if (newValue is null) { 
      this.isNull(isNullable ? true : false); 
      _value = 0; }
    else {
      this.isNull(false);
      _value = to!int(newValue); 
    }
  }  

  override protected void set(Json newValue) {
    if (newValue.isEmpty) { 
      _value = 0; 
      this.isNull(isNullable ? true : false); }
    else {
      _value = newValue.get!int;
      this.isNull(false);
    }
  }

  alias opEquals = DData.opEquals;
  /* override */ bool opEquals(int equalValue) {
    return (_value == equalValue);
  }
  override bool opEquals(string equalValue) {
    return (_value == to!int(equalValue));
  }
  ///
  unittest {
    auto intValue = new DIntegerValue(100);
    auto intValue100 = new DIntegerValue(100);
    auto intValue10 = new DIntegerValue(10);

    assert(intValue == 100);
    assert(intValue != 10);
    assert(intValue == intValue100);
    assert(intValue != intValue10);
    assert(intValue == "100");
    assert(intValue != "10");
  }

  int opCall() {
    return _value; 
  }

  O opCall(this O)(int newValue) { 
    _value = newValue;
    return cast(O)this; }
  version(test_uim_models) { unittest {    
      auto value = IntegerValue;
      value(100);
    }
  }  

  override DData copy() {
    return IntegerValue(attribute, toJson);
  }
  override DData dup() {
    return IntegerValue(attribute, toJson);
  }

  int toLong() { 
    if (isNull) return 0; 
    return _value; }

  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(_value); }

  override string toString() { 
    if (isNull) return "null"; 
    return to!string(_value); }
}
mixin(ValueCalls!("IntegerValue", "int"));  

version(test_uim_models) { unittest {    
    assert(IntegerValue.value("100").toLong == 100);
    assert(IntegerValue.value(Json(100)).toLong == 100);
    assert(IntegerValue.value("200").toLong != 100);
    assert(IntegerValue.value(Json(200)).toLong != 100);

    assert(IntegerValue.value("100").toString == "100");
    assert(IntegerValue.value(Json(100)).toString == "100");
    assert(IntegerValue.value("200").toString != "100");
    assert(IntegerValue.value(Json(200)).toString != "100");

    assert(IntegerValue.value("100").toJson == Json(100));
    assert(IntegerValue.value(Json(100)).toJson == Json(100));
    assert(IntegerValue.value("200").toJson != Json(100));
    assert(IntegerValue.value(Json(200)).toJson != Json(100));
}} 

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
doubleValue()
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
longValue()
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