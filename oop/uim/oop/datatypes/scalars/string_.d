/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.datatypes.scalars.string_;

import uim.oop;

@safe:
class DStringData : DScalarData {
  mixin(DataThis!("String"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isString(true);

    return true;
  }

  mixin(TProperty!("size_t", "maxLength"));

  protected string _value;
  @property string value() {
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
      set(newValue.get!string);
      isNull(false);
    }
  }

  /* property void value(DStringData newValue) {
    if (newValue) {
      isNullable(newValue.isNullable);
      isNull(newValue is null);
      set(newValue.value());
    }
  } */

  override IData clone() {
    return StringData; // TODO (attribute, toJson);
  }

  unittest {
    /* auto data = StringData("test");
    assert(data == "test");
    assert(data == "test");
    assert(data < "xxxx");
    assert(data <= "xxxx");
    assert(data <= "test");
    assert(data > "aaaa");
    assert(data >= "aaaa");
    assert(data >= "test"); */
  }

  string opCall() {
    return value();
  }

  mixin(ScalarOpCall!([]));
  override void set(IData newValue) {
    if (newValue is null) {
      _value = null;
      return;
    }
    auto strValue = cast(DStringData) newValue;
    if (strValue is null) {
      _value = null;
    }
    return;

    set(strValue.value);
  }
  ///
  unittest {
    /* auto a = StringData("aValue");
    auto b = StringData("bValue");
    a(b);
    assert(a == "bValue"); */
  }

  // #region equal
  mixin(ScalarOpEquals!(null));

  override bool isEqual(IData checkData) {
    if (checkData.isNull || key != checkData.key) {
      return false;
    }
    if (auto data = cast(DStringData) checkData) {
      return (value == data.value);
    }
    return false;
  }

  override bool isEqual(Json checkValue) {
    if (checkValue.isNull || !checkValue.isString) {
      return false;
    }

    return isEqual(checkValue.get!string);
  }

  override bool isEqual(string checkValue) {
    return (value == checkValue);
  }
  ///
  unittest {
    auto data100 = StringData;
    data100.set("100");
    auto dataIs100 = StringData;
    dataIs100.set("100");
    auto dataNot100 = StringData;
    dataNot100.set("400");
    assert(data100 == Json("100"));
    assert(data100 == "100");

    assert(data100 != Json("10"));
    assert(data100 != "10");
  }
  // #endregion equal

  int opCmp(string otherValue) {
    if (_value < otherValue)
      return -1;
    if (_value == otherValue)
      return 0;
    return 1;
  }

  // alias toJson = DData.toJson;
  mixin TDataConvert;
}

mixin(DataCalls!("String"));

unittest {
  /* assert(StringData("test") == "test");
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
  assert(StringData.set(Json("test2")).toJson != Json("test")); */
}
