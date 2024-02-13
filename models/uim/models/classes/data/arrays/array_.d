/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.arrays.array_;

import uim.models;

@safe:
class DArrayData : DData {
  mixin(DataThis!("ArrayData", "IData[]"));
  this(IData[] values) {
    this();
    _items = values.dup;
  }

  IData[] _items;

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    isArray(true);

    return true;
  }

  DArrayData add(IData[] values...) {
    this.add(values.dup);
    return this;
  }

  DArrayData add(IData[] values) {
    _items ~= values.dup;
    return this;
  }
  /// 
  unittest {
    // writeln(ArrayData.add(StringData("1x"), StringData("2x")).get.map!(v => v.toString).array);
  }

  // #region equal
  mixin(ScalarDataOpEquals!("IData[]"));

  override bool isEqual(IData[string] checkData) {
    return false;
  }

  override bool isEqual(IData checkData) {
    return false;
  }

  override bool isEqual(Json checkValue) {
    if (checkValue.isNull
      || !checkValue.isArray
      || checkValue.length != length) {
      return false;
    }

    for (auto i = 0; i < checkValue.length; i++) {
      _items[i].isEqual(checkValue[i]);
    }
    return false;
  }

  override bool isEqual(string checkValue) {
    return false; // (get == to!int(checkValue));
  }

  bool isEqual(IData[] checkValue) {
    return false; // (get == checkValue);
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

  protected IData[] _values;
  IData[] get() {
    return _values;
  }

  void set(IData[] newValues) {
    _values = newValues;
  }

  IData[] opCall() {
    return get();
  }

  void opCall(IData[] newValue) {
    set(newValue);
  }

  override void set(string newValue) {
    if (newValue is null) {
      isNull(isNullable ? true : false);
      // set(null);
    } else {
      isNull(false);
      // set(to!IData[](newValue));
    }
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      _items = null;
      isNull(isNullable ? true : false);
    } else {
      isNull(false);
    }
  }

  override IData clone() {
    return ArrayData; // (attribute, toJson);
  }

  override size_t length() {
    return _values.length;
  }

  void clear() {
    _values = null;
  }

  alias hasKey = DData.hasKey;
  bool hasKey(string checkKey) {
    return false;
  }
  ///
  unittest {
    /* assert(!hasKey("abc")); */
  }

  void opOpAssign(string op : "~")(IData value) {
    _values ~= value;
  }
  /// 
  unittest {
    auto data = new DArrayData;
    assert(data.length == 0);
    data ~= StringData;
    assert(data.length == 1);
  }

  override string toString() {
    return "[" ~ _items.map!(item => item.toString).join(",") ~ "]";
  }
}

mixin(DataCalls!("ArrayData"));
auto ArrayData(IData[] values) {
  return new DArrayData(values);
}

///
unittest {
  auto value = new DArrayData;
  assert(value.isArray);
}
