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
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isBoolean(true);

    return true;
  }

  protected bool _value;
  bool get() {
    return _value;
  }
  // alias get this;
  unittest {
    /* bool myValue = true;
    assert(BoolData(myValue).get == myValue);

    auto data = new DBoolData;
    data.set(myValue);
    assert(data.get == myValue);

    data = BoolData(false);
    data.get = myValue;
    assert(data.get == myValue); */
  }

  void set(bool newValue) {
    _value = newValue;
  }

  override void set(string newValue) {
    _value = (newValue.toLower == "true") || (newValue.toLower == "on") || (newValue.toLower == "1");
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      set(false);
      isNull(isNullable ? true : false);
    } else {
      set(newValue.get!bool);
      isNull(false);
    }
  }

// #region equal
    mixin(ScalarDataOpEquals!("bool"));

    override bool isEqual(IData[string] checkData) {
      return false;
    }

    override bool isEqual(IData checkData) {
      if (checkData.isNull || key != checkData.key) {
        return false;
      }
      if (auto boolData = cast(DBoolData) checkData) {
        return (get == boolData.get);
      }
      return false;
    }

    override bool isEqual(Json checkValue) {
      if (checkValue.isNull || !checkValue.isBoolean) {
        return false;
      }

      return (get == checkValue.get!bool);
    }

    override bool isEqual(string checkValue) {
      return (get == to!bool(checkValue));
    }

    bool isEqual(bool checkValue) {
      return (get == checkValue);
    }
    ///
    unittest {
      auto boolDataTrue = BoolData;
      boolDataTrue.set(true);
      auto boolDataIstrue = BoolData;
      boolDataIstrue.set(true);
      auto boolDataNottrue = BoolData;
      boolDataNottrue.set(false);
      assert(boolDataTrue == Json(true));
      assert(boolDataTrue == "true");
      assert(boolDataTrue == true);

      assert(boolDataTrue != Json(false));
      assert(boolDataTrue != "false");
      assert(boolDataTrue != false);
    }
  // #endregion equal

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
    /*auto valueA = new DBoolData(true);
    auto valueB = new DBoolData(false);
    assert(valueA > false);
    assert(valueB < true); */
  }

  int opCmp(DBoolData aValue) {
    if (aValue) {
      return opCmp(aValue.get());
    }
    return -1;
  }
  ///
  unittest {
    /* auto dataA = new DBoolData(true);
    auto dataB = new DBoolData(false);
    assert(dataA > dataB);
    assert(dataB < dataA);

    dataA = BoolData(true);
    dataB = BoolData(false);
    assert(dataA > dataB);
    assert(dataB < dataA);*/
  }

  override IData clone() {
    return BoolData; // TODO (attribute, toJson);
  }

  bool toBool() {
    return _value;
  }

  mixin DataConvertTemplate;
}

mixin(DataCalls!("BoolData", "bool"));

version (test_uim_models) {
  unittest {
    assert(BoolData(true) == true);
    assert(BoolData(false) != true);
    /* assert(BoolData.value(true) == true);
    assert(BoolData.set(Json(true)) == true);
    assert(BoolData.value(false) != true);
    assert(BoolData.set(Json(false)) != true); */

    auto BoolData = BoolData;

    BoolData.set("true");
    assert(BoolData.get());

    BoolData.set("false");
    assert(!BoolData.get());

    BoolData.set("on");
    assert(BoolData.get());

    BoolData.set("off");
    assert(!BoolData.get());

    BoolData.set("1");
    assert(BoolData.get());

    BoolData.set("0");
    assert(!BoolData.get());

    BoolData.value(true);
    assert(BoolData.fromString(BoolData.toString).get());
    assert(BoolData.fromJson(BoolData.toJson).get());

    BoolData.value(false);
    assert(!BoolData.fromString(BoolData.toString).get());
    assert(!BoolData.fromJson(BoolData.toJson).get());
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
