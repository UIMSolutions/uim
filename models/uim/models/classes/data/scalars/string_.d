/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.scalars.string_;

import uim.models;

@safe:
class DStringData : DData {
  mixin(DataThis!("StringData"));
  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    isString(true);

    return true;
  }

  mixin(TProperty!("size_t", "maxLength"));

  protected string _value;
  @property string get() {
    if (maxLength > 0 && _value.length > maxLength) {
      return _value[0 .. maxLength];
    } else {
      return _value;
    }
  }
  ///
  unittest {
    auto data = StringData;
    data.set("test");
    assert(data.value == "test");
    data.set("test2");
    assert(data.value == "test2");
  }

  // Hooks for setting 
  override void set(string newValue) {
    if (newValue is null) {
      isNull(isNullable ? true : false);
    } else {
      isNull(false);
    }
    _value = newValue;
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      _value = null;
      isNull(isNullable ? true : false);
    } else {
      _value = newValue.get!string;
      isNull(false);
    }
  }

  @property void value(DStringData newValue) {
    if (newValue) {
      isNullable(newValue.isNullable);
      isNull(newValue.isNull);
      set(newValue.value);
    }
  }

  override IData clone() {
    return StringData(attribute, toJson);
  }

  unittest {
    auto data = StringData("test");
    assert(data == "test");
    assert(data == "test");
    assert(data < "xxxx");
    assert(data <= "xxxx");
    assert(data <= "test");
    assert(data > "aaaa");
    assert(data >= "aaaa");
    assert(data >= "test");
  }

  string opCall() {
    return get();
  }

  void opCall(DStringData newValue) {
    set(newValue);
  }

  ///
  unittest {
    auto a = StringData("aValue");
    auto b = StringData("bValue");
    a(b);
    assert(a == "bValue");
  }

  alias opEquals = DData.opEquals;
  override bool opEquals(string otherValue) {
    return (_value == otherValue);
  }

  int opCmp(string otherValue) {
    if (_value < otherValue)
      return -1;
    if (_value == otherValue)
      return 0;
    return 1;
  }

  alias toJson = DData.toJson;
  override Json toJson() {
    if (isNull)
      return Json(null);
    return Json(_value);
  }

  override string toString() {
    if (isNull)
      return null;
    return _value;
  }
}

mixin(DataCalls!("StringData"));

unittest {
  assert(StringData("test") == "test");
  assert(StringData("test") < "xxxx");
  assert(StringData("test") <= "xxxx");
  assert(StringData("test") <= "test");
  assert(StringData("test") > "aaaa");
  assert(StringData("test") >= "aaaa");
  assert(StringData("test") >= "test");

  assert(StringData()("test") == "test");
  assert(StringData()("test") < "xxxx");
  assert(StringData()("test") <= "xxxx");
  assert(StringData()("test") <= "test");
  assert(StringData()("test") > "aaaa");
  assert(StringData()("test") >= "aaaa");
  assert(StringData()("test") >= "test");

  assert(StringData("test").value == "test");
  assert(StringData("test2").value != "test");

  assert(StringData(Json("test")).value == "test");
  assert(StringData(Json("test2")).value != "test");

  assert(StringData.set("test").value == "test");
  assert(StringData.set("test2").value != "test");

  assert(StringData.set(Json("test")).value == "test");
  assert(StringData.set(Json("test2")).value != "test");

  assert(StringData("test").toString == "test");
  assert(StringData("test2").toString != "test");

  assert(StringData(Json("test")).toString == "test");
  assert(StringData(Json("test2")).toString != "test");

  assert(StringData.set("test").toString == "test");
  assert(StringData.set("test2").toString != "test");

  assert(StringData.set(Json("test")).toString == "test");
  assert(StringData.set(Json("test2")).toString != "test");

  assert(StringData("test").toJson == Json("test"));
  assert(StringData("test2").toJson != Json("test"));

  assert(StringData(Json("test")).toJson == Json("test"));
  assert(StringData(Json("test2")).toJson != Json("test"));

  assert(StringData.set("test").toJson == Json("test"));
  assert(StringData.set("test2").toJson != Json("test"));

  assert(StringData.set(Json("test")).toJson == Json("test"));
  assert(StringData.set(Json("test2")).toJson != Json("test"));
}
