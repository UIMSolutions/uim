/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.scalars.double_;

import uim.models;

@safe:
class DDoubleData : DData {
  mixin(DataThis!("DoubleData", "double"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    isDouble(true);

    return true;
  }

  protected double _value;
  alias value = DData.value;
  void value(double newValue) {
    this.set(newValue);
  }

  double value() {
    return _value;
  }

  unittest {
    double myValue = 42.0;
    assert(DoubleData(myValue).value == myValue);

    auto data = new DDoubleData;
    data.value(myValue);
    assert(data.value == myValue);

    data = new DDoubleData;
    data.value = myValue;
    assert(data.value == myValue);
  }
  // Hooks for setting 
  protected void set(double newValue) {
    _value = newValue;
  }

  override protected void set(string newValue) {
    if (newValue is null) {
      isNull(isNullable ? true : false);
      _value = 0;
    } else {
      isNull(false);
      _value = to!double(newValue);
    }
  }

  override protected void set(Json newValue) {
    if (newValue.isEmpty) {
      _value = 0;
      this.isNull(isNullable ? true : false);
    } else {
      _value = newValue.get!double;
      this.isNull(false);
    }
  }

  alias opEquals = Object.opEquals;
  alias opEquals = DData.opEquals;
  bool opEquals(double aValue) {
    return (_value == aValue);
  }

  double opCall() {
    return _value;
  }

  void opCall(double newValue) {
    _value = newValue;
  }

  version (test_uim_models) {
    unittest {
      void value = DoubleData;
      value(100);
    }
  }

  override IData clone() {
    return DoubleData(attribute, toJson);
  }

  double toDouble() {
    if (isNull)
      return 0;
    return _value;
  }

  override Json toJson() {
    if (isNull)
      return Json(null);
    return Json(_value);
  }

  override string toString() {
    if (isNull)
      return "0";
    return to!string(_value);
  }
}

mixin(DataCalls!("DoubleData", "double"));

version (test_uim_models) {
  unittest {
    assert(DoubleData.value("100").toDouble == 100);
    assert(DoubleData.value(Json(100)).toDouble == 100);
    assert(DoubleData.value("200").toDouble != 100);
    assert(DoubleData.value(Json(200)).toDouble != 100);

    assert(DoubleData.value("100").toString == "100");
    assert(DoubleData.value(Json(100)).toString == "100");
    assert(DoubleData.value("200").toString != "100");
    assert(DoubleData.value(Json(200)).toString != "100");

    assert(DoubleData.value("100").toJson == Json(100));
    assert(DoubleData.value(Json(100)).toJson == Json(100));
    assert(DoubleData.value("200").toJson != Json(100));
    assert(DoubleData.value(Json(200)).toJson != Json(100));
  }
}

///
unittest {
  auto boolValue = new DBooleanData(true);
  assert(boolValue == true);
  assert(boolValue != false);
}
