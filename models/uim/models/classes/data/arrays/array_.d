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

  // TODO alias opEquals = IData.opEquals;

  protected IData[] _values;
  IData[] get() { return _values; }
  void set(IData[] newValues) { _values = newValues; }

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
      // set(null);
      isNull(isNullable ? true : false);
    } else {
      // set(newValue.get!`~jType~`);
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
