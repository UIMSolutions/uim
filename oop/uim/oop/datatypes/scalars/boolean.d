/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.datatypes.scalars.boolean;

import uim.oop;

@safe:
class DBooleanData : DScalarData {
  /*
  mixin(DataThis!("Boolean"));
  this(bool newValue) {
    this();
    this.set(newValue);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isBoolean(true);
    typeName("boolean");

    return true;
  }

  protected bool _value;
  bool value() {
    return _value;
  }
  // alias get this;
  unittest {
    /* bool myValue = true;
    assert(BooleanData(myValue).value == myValue);

    auto data = new DBooleanData;
    data.set(myValue);
    assert(data.value == myValue);

    data = Json(false);
    data.value = myValue;
    assert(data.value == myValue); * /
  }

  // #region set
  mixin(ScalarOpCall!(["bool"]));
  void set(bool newValue) {
    _value = newValue;
  }

  override void set(IData newValue) {
    if (newValue is null) {
      _value = false;
      return;
    }
    auto boolValue = cast(DBooleanData) newValue;
    if (boolValue is null) {
      _value = false;
    }
      return;

    set(boolValue.value);
  }

  override void set(string newValue) {
    set((newValue.toLower == "true") || (newValue.toLower == "on") || (newValue.toLower == "1"));
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
  // #endregion set 

  // #region equal
  mixin(ScalarOpEquals!(["bool"]));
  override bool isEqual(IData checkData) {
    if (checkData.isNull || key != checkData.key) {
      return false;
    }

    auto data = cast(DBooleanData) checkData;
    return data !is null ? data.value : false;
  }

  override bool isEqual(Json checkValue) {
    if (checkValue.isNull || !checkValue.isBoolean) {
      return false;
    }

    return isEqual(checkValue.get!bool);
  }

  override bool isEqual(string checkValue) {
    return isEqual(to!bool(checkValue));
  }

  bool isEqual(bool checkValue) {
    return (_value == checkValue);
  }
  ///
  unittest {
    auto booleanDataTrue = BooleanData;
    booleanDataTrue.set(true);
    auto booleanDataIstrue = BooleanData;
    booleanDataIstrue.set(true);
    auto booleanDataNottrue = BooleanData;
    booleanDataNottrue.set(false);
    assert(booleanDataTrue == Json(true));
    assert(booleanDataTrue == "true");
    assert(booleanDataTrue == true);

    assert(booleanDataTrue != Json(false));
    assert(booleanDataTrue != "false");
    assert(booleanDataTrue != false);
  }
  // #endregion equal

  // #region opCmp
  alias opCmp = Object.opCmp;
  int opCmp(bool valueToCompare) {
    if (value < valueToCompare)
      return -1;
    if (value > valueToCompare)
      return 1;
    return 0;
  }
  ///
  unittest {
    auto valueA = Json(true);
    auto valueB = Json(false);
    assert(valueA > false);
    assert(valueB < true);
  }

  int opCmp(DBooleanData aValue) {
    if (aValue) {
      return opCmp(aValue.value());
    }
    return -1;
  }
  ///
  unittest {
    /* auto dataA = new DJson(true);
      auto dataB = new DJson(false);
      assert(dataA > dataB);
      assert(dataB < dataA);

      dataA = Json(true);
      dataB = Json(false);
      assert(dataA > dataB);
      assert(dataB < dataA);* /
  }
  // #endregion opCmp

  // #region clone
  override IData clone() {
    return BooleanData; // TODO (attribute, toJson);
  }
  // #endregion clone

  override bool toBoolean() {
    return _value;
  }

  mixin TDataConvert;
  */
}

mixin(DataCalls!("Boolean"));
/* auto BooleanData(bool newValue) {
  return new DBooleanData(newValue);
} */

/*
version (test_uim_models) {
  unittest {
    assert(Json(true) == true);
    assert(Json(false) != true);
    /* assert(BooleanData.value(true) == true);
    assert(BooleanData.set(Json(true)) == true);
    assert(BooleanData.value(false) != true);
    assert(BooleanData.set(Json(false)) != true); * /

    auto BooleanData = BooleanData;

    BooleanData.set("true");
    assert(BooleanData.value());

    BooleanData.set("false");
    assert(!BooleanData.value());

    BooleanData.set("on");
    assert(BooleanData.value());

    BooleanData.set("off");
    assert(!BooleanData.value());

    BooleanData.set("1");
    assert(BooleanData.value());

    BooleanData.set("0");
    assert(!BooleanData.value());

    BooleanData.value(true);
    assert(BooleanData.fromString(BooleanData.toString).value());
    assert(BooleanData.fromJson(BooleanData.toJson).value());

    BooleanData.value(false);
    assert(!BooleanData.fromString(BooleanData.toString).value());
    assert(!BooleanData.fromJson(BooleanData.toJson).value());
  } * /
}

/* booleanean

Optional<DynamicConstantDesc<Booleanean>>
describeConstable()
Returns an Optional containing the nominal descriptor for this instance.
booleanean
equals(Object obj)
Returns true if and only if the argument is not null and is a Booleanean object that represents the same booleanean value as this object.
static booleanean
getBooleanean(String name)
Returns true if and only if the system property named by the argument exists and is equal to, ignoring case, the string "true".
int
hashCode()
Returns a hash code for this Booleanean object.
static int
hashCode(booleanean value)
Returns a hash code for a booleanean value; compatible with Booleanean.hashCode().
static booleanean
logicalAnd(booleanean a, booleanean b)
Returns the result of applying the logical AND operator to the specified booleanean operands.
static booleanean
logicalOr(booleanean a, booleanean b)
Returns the result of applying the logical OR operator to the specified booleanean operands.
static booleanean
logicalXor(booleanean a, booleanean b)
Returns the result of applying the logical XOR operator to the specified booleanean operands.
static booleanean
parseBooleanean(String s)
Parses the string argument as a booleanean.
String
toString()
Returns a String object representing this Booleanean's value.
static String
toString(booleanean b)
Returns a String object representing the specified booleanean.
static Booleanean
valueOf(booleanean b)
Returns a Booleanean instance representing the specified booleanean value.
static Booleanean
valueOf(String s)
Returns a Booleanean with a value represented by the specified string.
 */
