/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.scalars.boolean;

import uim.models;

@safe:
class DBoolData : DData {
  mixin(DataThis!("BoolData", "bool"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    isBoolean(true);

    return true;
  }

  @property int get() {
    return value;
  }
  // alias get this;
  unittest {
    bool myValue = true;
    assert(BoolData(myValue).value == myValue);

    auto data = new DBoolData;
    data.value(myValue);
    assert(data.value == myValue);

    data = BoolData(false);
    data.value = myValue;
    assert(data.value == myValue);
  }

  void opCall(bool newValue) {
    this.value(newValue);
  }

  protected bool _value;
  alias value = DData.value;
  void value(bool newValue) {
    this.set(newValue);

  }

  bool value() {
    return _value;
  }

  void set(bool newValue) {
    _value = newValue;
  }

  override void set(string newValue) {
    _value = (newValue.toLower == "true") || (newValue.toLower == "on") || (newValue.toLower == "1");
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      value(false);
      isNull(isNullable ? true : false);
    } else {
      value(newValue.get!bool);
      isNull(false);
    }
  }

  alias opEquals = DData.opEquals;
  bool opEquals(bool otherValue) {
    return (_value == otherValue);
  }

  override bool opEquals(string otherValue) {
    return (_value ? otherValue.toLower == "true" : otherValue.toLower == "false");
  }

  alias opCmp = Object.opCmp;
  int opCmp(bool aValue) {
    if (_value < aValue)
      return -1;
    if (_value == aValue)
      return 0;
    return 1;
  }
  ///
  unittest {
    auto valueA = new DBoolData(true);
    auto valueB = new DBoolData(false);
    assert(valueA > false);
    assert(valueB < true);
  }

  int opCmp(DBoolData aValue) {
    if (aValue) {
      return opCmp(aValue.value);
    }
    return -1;
  }
  ///
  unittest {
    auto dataA = new DBoolData(true);
    auto dataB = new DBoolData(false);
    assert(dataA > dataB);
    assert(dataB < dataA);

    dataA = BoolData(true);
    dataB = BoolData(false);
    assert(dataA > dataB);
    assert(dataB < dataA);
  }

  override IData clone() {
    return BoolData(attribute, toJson);
  }

  bool toBool() {
    return _value;
  }

  mixin DataConvert;
}

mixin(DataCalls!("BoolData", "bool"));

version (test_uim_models) {
  unittest {
    assert(BoolData(true) == true);
    assert(BoolData(false) != true);
    assert(BoolData.value(true) == true);
    assert(BoolData.value(Json(true)) == true);
    assert(BoolData.value(false) != true);
    assert(BoolData.value(Json(false)) != true);

    auto BoolData = BoolData;

    BoolData.value("true");
    assert(BoolData.value);

    BoolData.value("false");
    assert(!BoolData.value);

    BoolData.value("on");
    assert(BoolData.value);

    BoolData.value("off");
    assert(!BoolData.value);

    BoolData.value("1");
    assert(BoolData.value);

    BoolData.value("0");
    assert(!BoolData.value);

    BoolData.value(true);
    assert(BoolData.fromString(BoolData.toString).value);
    assert(BoolData.fromJson(BoolData.toJson).value);

    BoolData.value(false);
    assert(!BoolData.fromString(BoolData.toString).value);
    assert(!BoolData.fromJson(BoolData.toJson).value);
  }
}

/* boolean

Optional<DynamicConstantDesc<Boolean>>
describeConstable()
Returns an Optional containing the nominal descriptor for this instance.
boolean
equals(Object obj)
Returns true if and only if the argument is not null and is a Boolean object that represents the same boolean value as this object.
static boolean
getBoolean(String name)
Returns true if and only if the system property named by the argument exists and is equal to, ignoring case, the string "true".
int
hashCode()
Returns a hash code for this Boolean object.
static int
hashCode(boolean value)
Returns a hash code for a boolean value; compatible with Boolean.hashCode().
static boolean
logicalAnd(boolean a, boolean b)
Returns the result of applying the logical AND operator to the specified boolean operands.
static boolean
logicalOr(boolean a, boolean b)
Returns the result of applying the logical OR operator to the specified boolean operands.
static boolean
logicalXor(boolean a, boolean b)
Returns the result of applying the logical XOR operator to the specified boolean operands.
static boolean
parseBoolean(String s)
Parses the string argument as a boolean.
String
toString()
Returns a String object representing this Boolean's value.
static String
toString(boolean b)
Returns a String object representing the specified boolean.
static Boolean
valueOf(boolean b)
Returns a Boolean instance representing the specified boolean value.
static Boolean
valueOf(String s)
Returns a Boolean with a value represented by the specified string.
 */
