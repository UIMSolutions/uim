/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.data.array;

import uim.oop;

class DArrayData : DData {
  this() {
    super();
  }

  this(IData[] newValues) {
    this().values(newValues);
  }

  protected IData[] _values;
  override IData[] values() {
    return _values;
  }
  void values(IData[] newValues) {
    _values = newValues;
  }
  ///
  unittest {
    // TODO
  }

  size_t length() {
    return _values.length;
  }

  void clear() {
      _values = null;
  }

  void opOpAssign(string op: "~")(IData value) {
    values ~= value;
  }
  /// 
  unittest {
    auto data = new DArrayData;
    assert(data.length == 0);
    data ~= StringData;
    assert(data.length == 1);
  }

  alias hasKey = DData.hasKey;
  bool hasKey(string checkKey) {
    return false;
  }
  ///
  unittest {
    assert(!hasKey("abc"));
  }
}

auto ArrayData() {
  return new DArrayData;
}

auto ArrayData(IData[] newValues) {
  return new DArrayData(newValues);
}
