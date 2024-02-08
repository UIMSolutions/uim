/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.arrays.array_;

import uim.models;

@safe:
class DArrayData : DData {
  mixin(DataThis!("ArrayData"));  
  this(IData[] values) {
    this();
    _items = values.dup;
  }

  IData[] _items;

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }

    this
      .isArray(true);
  }

  DArrayData add(IData[] values...) { 
    this.add(values.dup); 
    return this; }

  DArrayData add(IData[] values) {
    _items ~= values.dup; 
    return this;
  }
  /// 
  unittest {
    writeln(ArrayData.add(StringData("1x"), StringData("2x")).values.map!(v => v.toString).array);
  }
  
  alias opEquals = IData.opEquals;

  protected IData[] _values;
  override IData[] values() {
    return _values;
  }
  void values(IData[] newValues) {
    _values = newValues;
  }

  override IData copy() {
    return ArrayData(attribute, toJson);
  }
  override IData dup() {
    return copy;
  }

  size_t length() {
    return _values.length;
  }

  void clear() {
      _values = null;
  }

  bool hasKey(string checkKey) {
    return false;
  }
    ///
  unittest {
    assert(!hasKey("abc"));
  }

  void opOpAssign(string op: "~")(IData value) {
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
    return "["~_items.map!(item => item.toString).join(",")~"]";
  }
}
mixin(ValueCalls!("ArrayData")); 
auto ArrayData(IData[] values) { return new DArrayData(values); } 

///
unittest {
  autvoid value = new DArrayData;
  assert(value.isArray);
}