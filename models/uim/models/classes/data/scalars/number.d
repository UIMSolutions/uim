/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.datatypes.scalars.number;

import uim.models;

@safe:
class DNumberData : DScalarData {
  mixin(DataThis!("Number"));
  mixin TDataConvert;
  
  this(double newValue) {
    this();
    set(newValue);
  }

  this(string name, double newValue) {
    this(name);
    set(newValue);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isNumber(true);
    typeName("number");
    set(0.0);

    return true;
  }

  // #region Getter & Setter
  protected double _value;
  double value() {
    return _value;
  }

  // #region set
  mixin(ScalarOpCall!(["int", "long", "float", "double"]));

  override void set(IData newValue) {
    if (newValue.isNull) {
      _value = 0.0;
      return;
    }

    auto numberValue = cast(DNumberData)newValue;
    if (numberValue.isNull) {
      _value = 0.0;
      return;
    }

    set(numberValue.value);
  }

  override void set(Json newValue) {
    if (newValue.isInteger /* || newValue.isDouble */ ) {
      set(newValue.get!double);
    }

    if (newValue.isString) {
      set(newValue.get!string);
    }
  }

  override void set(string newValue) {
    if (newValue.isNumeric) {
      set(to!double(newValue));
    }
  }

  void set(int newValue) {
    _value = to!double(newValue);
  }

  void set(long newValue) {
    _value = to!double(newValue);
  }

  void set(float newValue) {
    _value = to!double(newValue);
  }

  void set(double newValue) {
    _value = newValue;
  }
  // #endregion set
  ///
  unittest {
    auto data = NumberData(0.0);
    data.set(1.1);
    writeln(data);
  }
  // #endregion Getter & Setter
  ///
  unittest {
    /* number myValue = 42.0;
    auto data = NumberData(myValue);
    assert(data.value == myValue);

    data = new DNumberData;
    data.set(myValue);
    assert(data.value == myValue);

    data = new DNumberData;
    data.value = myValue;
    assert(data.value == myValue); */
  }

  // #region equal
  mixin(ScalarOpEquals!(["float", "double"]));

  override bool isEqual(IData checkData) {
    if (checkData.isNull) {
      return false;
    }

    auto data = cast(DNumberData) checkData;
    if (data.isNull) {
      return false;
    }

    return isEqual(data.value);
  }

  override bool isEqual(Json checkValue) {
    if (checkValue.isNull || !checkValue.isFloat) {
      return false;
    }

    return isEqual(checkValue.get!double);
  }

  override bool isEqual(string checkValue) {
    return isEqual(to!double(checkValue));
  }

  bool isEqual(float checkValue) {
    return isEqual(to!double(checkValue));
  }

  bool isEqual(double checkValue) {
    return (value == checkValue);
  }
  ///
  unittest {
    auto data100 = NumberData;
    data100.set(100.0);
    auto dataIs100 = NumberData;
    dataIs100.set(100.0);
    auto dataNot100 = NumberData;
    dataNot100.set(400.0);
    // assert(data100 == dataIs100);
    assert(data100 == Json(100.0));
    assert(data100 == "100.0");
    assert(data100 == 100.0);

    // assert(data100 != dataNot100);
    assert(data100 != Json(10.0));
    assert(data100 != "10.0");
    assert(data100 != 10.0);
  }
  // #endregion equal

  override IData clone() {
    return NumberData; // TODO (attribute, toJson);
  }

  double toNumber() {
    if (isNull)
      return 0;
    return _value;
  }


}

mixin(DataCalls!("Number"));
/* auto NumberData(double newValue) {
  return new DNumberData(newValue);
} */

unittest {
  /*alias Alias = ;
  
  assert(NumberData("100").toNumber == 100);
  assert(NumberData(Json(100)).toNumber == 100);
  assert(NumberData("200").toNumber != 100);
  assert(NumberData(Json(200)).toNumber != 100);

  assert(NumberData("100").toString == "100");
  assert(NumberData(Json(100)).toString == "100");
  assert(NumberData("200").toString != "100");
  assert(NumberData(Json(200)).toString != "100");

  assert(NumberData("100").toJson == Json(100));
  assert(NumberData(Json(100)).toJson == Json(100));
  assert(NumberData("200").toJson != Json(100));
  assert(NumberData(Json(200)).toJson != Json(100)); 
  */
}

///
unittest {
  /* auto boolValue = new DBoolData(true);
  assert(boolValue == true);
  assert(boolValue != false); */
}