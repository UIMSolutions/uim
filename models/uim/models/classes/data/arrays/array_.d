/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.data.arrays.array_;

import uim.models;

@safe:
class DArrayData : DData {
  mixin(DataThis!("Array"));

  this(IData[] items) {
    this();
    _items = items.dup;
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

  DArrayData add(IData[] items...) {
    add(items.dup);
    return this;
  }

  DArrayData add(IData[] items) {
    _items ~= items.dup;
    return this;
  }
  /// 
  unittest {
    // writeln(ArrayData.add(Json("1x"), Json("2x")).get.map!(v => v.toString).array);
  }

  // #region equal
  /*  bool isEqual(IData checkData) {
    auto arrayData = cast(DArrayData)checkData;
    if (arrayData.isNull) {
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
  } */

  /* override bool isEqual(Json checkValue) {
    if (!checkValue.isArray) {
      return false;
    }

    IData[] items;
    for (auto i = 0; i < checkValue.length; i++) {
      // TODO items ~= checkValue[i].toData;
    }
    return isEqual(items);
  }

  bool isEqual(IData[] checkValue) {
    return false; // (get == checkValue);
  } */
  ///
  unittest {
    // TODO
  }
  // #endregion equal

  /* protected IData[] _items;
  IData[] value() {
    return _items;
  }

  void set(IData[] newValues) {
    _items = newValues;
  }

  IData[] opCall() {
    return value();
  }

  void opCall(IData[] newValue) {
    set(newValue);
  }

  override void set(string newValue) {
    if (newValue.isNull) {
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
    return new DArrayData; // (attribute, toJson);
  }

  override size_t length() {
    return _items.length;
  } */

  void clear() {
    set(Json(null));
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
    _items ~= value;
  }
  /// 
  unittest {
    auto data = new DArrayData;
    // TODO assert(data.length == 0);
    data ~= StringData;
    // TODO assert(data.length == 1);
  }

  /*  alias toJson = DData.toJson;
  override Json toJson() {
    return Json(_items.map!(item => item.toJson).array);
  }

  override string toString() {
    return "[" ~ _items.map!(item => item.toString).join(",") ~ "]";
  } */

  /*  override string[] toStringArray() {
    return _items.map!(item => item.toString).array;
  }  */
}

/*
mixin(DataCalls!("Array"));
auto ArrayData(IData[] items) {
  return new DArrayData(items);
}

///
unittest {
  auto value = new DArrayData;
// TODO assert(value.isArray);
}
*/
