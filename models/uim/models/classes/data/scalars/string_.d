/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.data.scalars.string_;

import uim.models;

@safe:
class DStringData : DScalarData {

  mixin(DataThis!("String"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isString(true);

    return true;
  }

  mixin(TProperty!("size_t", "maxLength"));
  protected string nullValue = null;

  protected string _value;
  @property void value(string newValue) {
      _value = maxLength > 0 && newValue.length > maxLength
      ? newValue[0 .. maxLength]
      : newValue;
  }
  @property string value() {
    return maxLength > 0 && _value.length > maxLength
      ? _value[0 .. maxLength]
      : _value;
  }

  ///
  unittest {
    // TODO assert(StringData("test").value == "test");   
    assert(StringData("test").value != "test2");

    auto data = StringData;
    data.maxLength(4);
    data.set("12345678");
    // TODO assert(StringData.value == "1234");   
  }

  // #region Getter
    override bool getBoolean() {
      return value.lower == "true"; 
    }

    override long getLong() {
      return to!long(value);
    }

    override double getDouble() {
      return to!double(value);
    }

    override string getString() {
      return value;
    }
  // #region Getter

  // Setters
  override void set(bool newValue) {    
    value(newValue ? "true" : "false");
  }

  override void set(long newValue) {    
    value(to!string(newValue));
  }

  override void set(double newValue) {    
    value(to!string(newValue));
  }

  override void set(string newValue) {
    newValue.isNull
      ? isNull(isNullable ? true : false)
      : isNull(false);
    value(newValue);
  }

  override void set(Json newValue) {
    newValue.isNull  
      ? set(nullValue)
      : set(newValue.getString);
  }

  /* property void value(DStringData newValue) {
    if (newValue) {
      isNullable(newValue.isNullable);
      isNull(newValue.isNull);
      set(newValue.value());
    }
  } */

  override IData clone() {
    return StringData; // TODO (attribute, toJson);
  }

  unittest {
    /* auto data = Json("test");
  // TODO assert(data == "test");
  // TODO assert(data == "test");
  // TODO assert(data < "xxxx");
  // TODO assert(data <= "xxxx");
  // TODO assert(data <= "test");
  // TODO assert(data > "aaaa");
  // TODO assert(data >= "aaaa");
  // TODO assert(data >= "test"); */
  }

/*  string opCall() {
    return null; 
    // TODO return value();
  } */

  /* mixin(ScalarOpCall!([]));
  override void set(IData newValue) {
    if (newValue.isNull) {
      _value = null;
      return;
    }
    auto strValue = cast(DStringData) newValue;
    if (strValue.isNull) {
      _value = null;
    }
    return;

    // TODO set(strValue.value);
  } */
  ///
  unittest {
    /* auto a = Json("aValue");
    auto b = Json("bValue");
    a(b);
  // TODO assert(a == "bValue"); */
  }

  // #region equal
  /* mixin(ScalarOpEquals!(null));

  override bool isEqual(IData checkData) {
    if (checkData.isNull || key != checkData.key) {
      return false;
    }
    if (auto data = cast(DStringData) checkData) {
      // TODO return (value == data.value);
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
    return false;
    // TODO return (value == checkValue);
  } */
  ///
  unittest {
    auto data100 = StringData;
    data100.set("100");
    auto dataIs100 = StringData;
    dataIs100.set("100");
    auto dataNot100 = StringData;
    dataNot100.set("400");
  // TODO assert(data100 == Json("100"));
  // TODO assert(data100 == "100");

  // TODO assert(data100 != Json("10"));
  // TODO assert(data100 != "10");
  }
  // #endregion equal

/*  int opCmp(string otherValue) {
    if (_value < otherValue)
      return -1;
    if (_value == otherValue)
      return 0;
    return 1;
  } */

  // alias toJson = DData.toJson;
  mixin TDataConvert; 
}

mixin(DataCalls!("String"));

unittest {
  /* assert(Json("test") == "test");
// TODO assert(Json("test") < "xxxx");
// TODO assert(Json("test") <= "xxxx");
// TODO assert(Json("test") <= "test");
// TODO assert(Json("test") > "aaaa");
// TODO assert(Json("test") >= "aaaa");
// TODO assert(Json("test") >= "test");

// TODO assert(StringData()("test") == "test");
// TODO assert(StringData()("test") < "xxxx");
// TODO assert(StringData()("test") <= "xxxx");
// TODO assert(StringData()("test") <= "test");
// TODO assert(StringData()("test") > "aaaa");
// TODO assert(StringData()("test") >= "aaaa");
// TODO assert(StringData()("test") >= "test");

// TODO assert(Json("test").value == "test");
// TODO assert(Json("test2").value != "test");

// TODO assert(StringData(Json("test")).value == "test");
// TODO assert(StringData(Json("test2")).value != "test");

// TODO assert(StringData.set("test").value == "test");
// TODO assert(StringData.set("test2").value != "test");

// TODO assert(StringData.set(Json("test")).value == "test");
// TODO assert(StringData.set(Json("test2")).value != "test");

// TODO assert(Json("test").toString == "test");
// TODO assert(Json("test2").toString != "test");

// TODO assert(StringData(Json("test")).toString == "test");
// TODO assert(StringData(Json("test2")).toString != "test");

// TODO assert(StringData.set("test").toString == "test");
// TODO assert(StringData.set("test2").toString != "test");

// TODO assert(StringData.set(Json("test")).toString == "test");
// TODO assert(StringData.set(Json("test2")).toString != "test");

// TODO assert(Json("test").toJson == Json("test"));
// TODO assert(Json("test2").toJson != Json("test"));

// TODO assert(StringData(Json("test")).toJson == Json("test"));
// TODO assert(StringData(Json("test2")).toJson != Json("test"));

// TODO assert(StringData.set("test").toJson == Json("test"));
// TODO assert(StringData.set("test2").toJson != Json("test"));

// TODO assert(StringData.set(Json("test")).toJson == Json("test"));
// TODO assert(StringData.set(Json("test2")).toJson != Json("test")); */
}
