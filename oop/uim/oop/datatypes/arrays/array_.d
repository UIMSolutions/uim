/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.datatypes.arrays.array_;

import uim.oop;

@safe:
class DArrayData : DData {
  /* 
  mixin(DataThis!("Array"));

  this(IData[] values) {
    this();
    _items = values.dup;
  }

  IData[] _items;

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
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
    // writeln(ArrayData.add(Json("1x"), Json("2x")).get.map!(v => v.toString).array);
  }

  // #region equal
  override bool isEqual(IData checkData) {
    auto arrayData = cast(DArrayData)checkData;
    if (arrayData is null) {
      return false;
    }

    if (length != checkData.length) {
      return false;
    }

    foreach(size_t index, item; _items) {
      if (!item.isEqual(checkData.at(index))) {
        return false;
      }
    }

    return true;
  }

  override bool isEqual(Json checkValue) {
    if (!checkValue.isArray) {
      return false;
    }

    IData[] values;
    for (auto i = 0; i < checkValue.length; i++) {
      values ~= checkValue[i].toData;
    }
    return isEqual(values);
  }

  bool isEqual(IData[] checkValue) {
    return false; // (get == checkValue);
  }
  ///
  unittest {
    // TODO
  }
  // #endregion equal

  protected IData[] _values;
  IData[] value() {
    return _values;
  }

  void set(IData[] newValues) {
    _values = newValues;
  }

  IData[] opCall() {
    return value();
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
    /* assert(!hasKey("abc")); * /
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

  alias toJson = DData.toJson;
  override Json toJson() {
    return Json(_items.map!(item => item.toJson).array);
  }

  override string toString() {
    return "[" ~ _items.map!(item => item.toString).join(",") ~ "]";
  }

  override string[] toStringArray() {
    return _items.map!(item => item.toString).array;
  } */
}

/*
mixin(DataCalls!("Array"));
auto ArrayData(IData[] values) {
  return new DArrayData(values);
}

///
unittest {
  auto value = new DArrayData;
  assert(value.isArray);
}
*/