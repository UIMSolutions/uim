/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.scalars.boolean;

import uim.models;

@safe:
class DBooleanData : DData {
  mixin(DataThis!("BooleanValue", "bool"));  

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .isBoolean(true);
  }

  @property int get() {
    return value;
  }
  // alias get this;

  O opCall(this O)(bool newValue) { this.value(newValue); return cast(O)this; }

  protected bool _value;
  alias value = DData.value;
  O value(this O)(bool newValue) {
    this.set(newValue);
    return cast(O)this; 
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
      this
        .value(false) 
        .isNull(isNullable ? true : false); }
    else {
      this
        .value(newValue.get!bool)
        .isNull(false);
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
    if (_value < aValue) return -1;
    if (_value == aValue) return 0;
    return 1;
  }
  ///
  unittest {
    auto valueA = new DBooleanValue(true);
    auto valueB = new DBooleanValue(false);
    assert(valueA > false);
    assert(valueB < true);
  }

  int opCmp(DBooleanValue aValue) {
    if (aValue) {
      return opCmp(aValue.value);
    }
    return -1;
  }

  ///
  unittest {
    auto valueA = new DBooleanValue(true);
    auto valueB = new DBooleanValue(false);
    assert(valueA > valueB);
    assert(valueB < valueA);

    auto valueC = (new DBooleanValue).value(true);
    auto valueD = (new DBooleanValue).value(false);
    assert(valueC > valueD);
    assert(valueD < valueC);
  }
  
  override IData copy() {
    return BooleanValue(attribute, toJson);
  }
  override IData dup() {
    return BooleanValue(attribute, toJson);
  }
  
  bool toBool() { 
    return _value; }

  override Json toJson() { 
    if (this.isNull) return Json(null); 
    return Json(this.value); }

  override string toString() { 
    if (isNull) return null; 
    return to!string(this.value); }
}
mixin(ValueCalls!("BooleanValue", "bool"));  

version(test_uim_models) { unittest {    
    assert(BooleanValue(true) == true);
    assert(BooleanValue(false) != true);
    assert(BooleanValue.value(true) == true);
    assert(BooleanValue.value(Json(true)) == true);
    assert(BooleanValue.value(false) != true);
    assert(BooleanValue.value(Json(false)) != true);

    auto booleanValue = BooleanValue;

    booleanValue.value("true");
    assert(booleanValue.value);

    booleanValue.value("false");
    assert(!booleanValue.value);

    booleanValue.value("on");
    assert(booleanValue.value);

    booleanValue.value("off");
    assert(!booleanValue.value);

    booleanValue.value("1");
    assert(booleanValue.value);

    booleanValue.value("0");
    assert(!booleanValue.value);

    booleanValue.value(true);
    assert(booleanValue.fromString(booleanValue.toString).value);
    assert(booleanValue.fromJson(booleanValue.toJson).value);

    booleanValue.value(false);
    assert(!booleanValue.fromString(booleanValue.toString).value);
    assert(!booleanValue.fromJson(booleanValue.toJson).value);
}}


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