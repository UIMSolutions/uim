/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module oop.uim.oop.datatypes.scalars.number;

import uim.oop;

@safe:
class DNumberData : DScalarData {
  mixin(DataThis!("Number"));

  this(double newValue) {
    this();
    set(newValue);
  }

  this(string name, double newValue) {
    this(name);
    set(newValue);
  }

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isNumber(true);
    typeName("number");
    set(0.0);

    return true;
  }

  // #region Getter & Setter
  double value() {
    return _value;
  }

  void set(double newValue) {
    _value = newValue;
  }

  void set(Json newValue) {
    if (newValue.isDouble) {
      set(newValue.get!double);
    }

    if (newValue.isInteger) {
      set(to!double(newValue.get!long));
    }

    if (newValue.isString) {
      value(newValue.get!string);
    }
  }

  void set(string newValue) {
    if (newValue.isNumeric) {
      set(to!double(newValue));
    }
  }
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
    assert(data.get == myValue);

    data = new DNumberData;
    data.set(myValue);
    assert(data.get == myValue);

    data = new DNumberData;
    data.value = myValue;
    assert(data.get == myValue); */
  }

  // #region equal
  mixin(ScalarDataOpEquals!("number"));

  override bool isEqual(IData checkData) {
    if (checkData.isNull) {
      return false;
    }
    
    auto data = cast(DNumberData)checkData;
    if (data is null) {
      return false;
    }

    return data.value == value;
  }

  override bool isEqual(Json checkValue) {
    if (checkValue.isNull || !checkValue.isFloat) {
      return false;
    }

    return (get == checkValue.get!number);
  }

  override bool isEqual(string checkValue) {
    return (get == to!number(checkValue));
  }

  bool isEqual(number checkValue) {
    return (get == checkValue);
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

  number toNumber() {
    if (isNull)
      return 0;
    return _value;
  }

  mixin DataConvertTemplate;
}

mixin(DataCalls!("NumberData", "number"));

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
