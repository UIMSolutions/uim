/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.scalars.long_;

import uim.models;

@safe:
class DLongData : DScalarData {
  mixin(DataThis!("LongData", "long"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    isLong(true);

    return true;
  }

  // #region Getter & Setter
  long get() {
    return _value;
  }

  void set(long newValue) {
    _value = newValue;
  }

  mixin(DataGetSetTemplate!("0", "long"));
  // #endregion Getter & Setter

  mixin DataConvertTemplate;

  alias opEquals = DData.opEquals;
  bool opEquals(long equalValue) {
    return (_value == equalValue);
  }

  override bool opEquals(string equalValue) {
    return (this == to!long(equalValue));
  }

  unittest {
    /* auto LongData = new DLongData(100);
    auto LongData100 = new DLongData(100);
    auto LongData10 = new DLongData(10);

    assert(LongData == 100);
    assert(LongData != 10);
    assert(LongData == LongData100);
    assert(LongData != LongData10);
    assert(LongData == "100");
    assert(LongData != "10"); */
  }

  alias opCmp = Object.opCmp;
  // Compares with long value
  int opCmp(long aValue) {
    if (_value < aValue)
      return -1;
    if (_value == aValue)
      return 0;
    return 1;
  }
  ///
  unittest {
    /* auto value = new DLongData(100_000);
    assert(value > 100);
    assert(value >= 100);
    assert(value >= 100_000);
    assert(value == 100_000);
    assert(value < 200_000);    
    assert(value <= 200_000);    
    assert(value <= 100_000);     */
  }

  // Compares with DLongData
  int opCmp(DLongData aValue) {
    return opCmp(aValue.get());
  }
  ///
  unittest {
    /* auto value = new DLongData(100_000);
    assert(value > new DLongData(100));
    assert(value >= new DLongData(100));
    assert(value >= new DLongData(100_000));
    assert(value == new DLongData(100_000));
    assert(value < new DLongData(200_000));    
    assert(value <= new DLongData(200_000));    
    assert(value <= new DLongData(100_000));     */
  }

  version (test_uim_models) {
    unittest {
      void value = LongData;
      value(100);
    }
  }

  override IData clone() {
    return LongData; // TODO (attribute, toJson);
  }

  long toLong() {
    if (isNull)
      return 0;
    return _value;
  }

}

mixin(DataCalls!("LongData", "long"));

unittest {
  auto data = LongData;
  data.set("100");
  assert(data.toLong == 100);
  /* assert(LongData.set(Json(100)).toLong == 100);
    assert(LongData.set("200").toLong != 100);
    assert(LongData.set(Json(200)).toLong != 100);

    assert(LongData.set("100").toString == "100");
    assert(LongData.set(Json(100)).toString == "100");
    assert(LongData.set("200").toString != "100");
    assert(LongData.set(Json(200)).toString != "100");

    assert(LongData.set("100").toJson == Json(100));
    assert(LongData.set(Json(100)).toJson == Json(100));
    assert(LongData.set("200").toJson != Json(100));
    assert(LongData.set(Json(200)).toJson != Json(100));*/
}

/*
static int
bitCount(long i)
Returns the number of one-bits in the two's complement binary representation of the specified long value.
byte
byteValue()
Returns the value of this Long as a byte after a narrowing primitive conversion.
static int
compare(long x, long y)

int
compareTo(Long anotherLong)
Compares two Long objects numerically.
static int
compareUnsigned(long x, long y)
Compares two long values numerically treating the values as unsigned.
static long
compress(long i, long mask)
Returns the value obtained by compressing the bits of the specified long value, i, in accordance with the specified bit mask.
static Long
decode(String nm)
Decodes a String into a Long.
Optional<Long>
describeConstable()
Returns an Optional containing the nominal descriptor for this instance, which is the instance itself.
static long
divideUnsigned(long dividend, long divisor)
Returns the unsigned quotient of dividing the first argument by the second where each argument and the result is interpreted as an unsigned value.
double
DoubleData()
Returns the value of this Long as a double after a widening primitive conversion.
boolean
equals(Object obj)
Compares this object to the specified object.
static long
expand(long i, long mask)
Returns the value obtained by expanding the bits of the specified long value, i, in accordance with the specified bit mask.
float
floatValue()
Returns the value of this Long as a float after a widening primitive conversion.
static Long
getLong(String nm)
Determines the long value of the system property with the specified name.
static Long
getLong(String nm, long val)
Determines the long value of the system property with the specified name.
static Long
getLong(String nm, Long val)
Returns the long value of the system property with the specified name.
int
hashCode()
Returns a hash code for this Long.
static int
hashCode(long value)
Returns a hash code for a long value; compatible with Long.hashCode().
static long
highestOneBit(long i)
Returns a long value with at most a single one-bit, in the position of the highest-order ("leftmost") one-bit in the specified long value.
int
intValue()
Returns the value of this Long as an int after a narrowing primitive conversion.
long
LongData()
Returns the value of this Long as a long value.
static long
lowestOneBit(long i)
Returns a long value with at most a single one-bit, in the position of the lowest-order ("rightmost") one-bit in the specified long value.
static long
max(long a, long b)
Returns the greater of two long values as if by calling Math.max.
static long
min(long a, long b)
Returns the smaller of two long values as if by calling Math.min.
static int
numberOfLeadingZeros(long i)
Returns the number of zero bits preceding the highest-order ("leftmost") one-bit in the two's complement binary representation of the specified long value.
static int
numberOfTrailingZeros(long i)
Returns the number of zero bits following the lowest-order ("rightmost") one-bit in the two's complement binary representation of the specified long value.
static long
parseLong(CharSequence s, int beginIndex, int endIndex, int radix)
Parses the CharSequence argument as a signed long in the specified radix, beginning at the specified beginIndex and extending to endIndex - 1.
static long
parseLong(String s)
Parses the string argument as a signed decimal long.
static long
parseLong(String s, int radix)
Parses the string argument as a signed long in the radix specified by the second argument.
static long
parseUnsignedLong(CharSequence s, int beginIndex, int endIndex, int radix)
Parses the CharSequence argument as an unsigned long in the specified radix, beginning at the specified beginIndex and extending to endIndex - 1.
static long
parseUnsignedLong(String s)
Parses the string argument as an unsigned decimal long.
static long
parseUnsignedLong(String s, int radix)
Parses the string argument as an unsigned long in the radix specified by the second argument.
static long
remainderUnsigned(long dividend, long divisor)
Returns the unsigned remainder from dividing the first argument by the second where each argument and the result is interpreted as an unsigned value.
Long
resolveConstantDesc(MethodHandles.Lookup lookup)
Resolves this instance as a ConstantDesc, the result of which is the instance itself.
static long
reverse(long i)
Returns the value obtained by reversing the order of the bits in the two's complement binary representation of the specified long value.
static long
reverseBytes(long i)
Returns the value obtained by reversing the order of the bytes in the two's complement representation of the specified long value.
static long
rotateLeft(long i, int distance)
Returns the value obtained by rotating the two's complement binary representation of the specified long value left by the specified number of bits.
static long
rotateRight(long i, int distance)
Returns the value obtained by rotating the two's complement binary representation of the specified long value right by the specified number of bits.
short
shortValue()
Returns the value of this Long as a short after a narrowing primitive conversion.
static int
signum(long i)
Returns the signum function of the specified long value.
static long
sum(long a, long b)
Adds two long values together as per the + operator.
static String
toBinaryString(long i)
Returns a string representation of the long argument as an unsigned integer in base 2.
static String
toHexString(long i)
Returns a string representation of the long argument as an unsigned integer in base 16.
static String
toOctalString(long i)
Returns a string representation of the long argument as an unsigned integer in base 8.
String
toString()
Returns a String object representing this Long's value.
static String
toString(long i)
Returns a String object representing the specified long.
static String
toString(long i, int radix)
Returns a string representation of the first argument in the radix specified by the second argument.
static String
toUnsignedString(long i)
Returns a string representation of the argument as an unsigned decimal value.
static String
toUnsignedString(long i, int radix)
Returns a string representation of the first argument as an unsigned integer value in the radix specified by the second argument.
static Long
valueOf(long l)
Returns a Long instance representing the specified long value.
static Long
valueOf(String s)
Returns a Long object holding the value of the specified String.
static Long
valueOf(String s, int radix)
*/

unittest {
  testDataSetGet(LongData);
}
