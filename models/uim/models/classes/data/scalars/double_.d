/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.scalars.double_;

import uim.models;

@safe:
class DDoubleData: DData {
  mixin(DataThis!("DoubleValue", "double"));  

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .isDouble(true);
  }

  protected double _value;  
  alias value = DData.value;
  O value(this O)(double newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  double value() {
    return _value; 
  }

  // Hooks for setting 
  protected void set(double newValue) {
    _value = newValue; 
  }  

  override protected void set(string newValue) {
    if (newValue is null) { 
      this.isNull(isNullable ? true : false); 
      _value = 0; }
    else {
      this.isNull(false);
      _value = to!double(newValue); 
    }
  }  

  override protected void set(Json newValue) {
    if (newValue.isEmpty) { 
      _value = 0; 
      this.isNull(isNullable ? true : false); }
    else {
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

  O opCall(this O)(double newValue) { 
    _value = newValue;
    return cast(O)this; }
  version(test_uim_models) { unittest {    
      auto value = DoubleValue;
      value(100);
    }
  }  

  override IData copy() {
    return DoubleValue(attribute, toJson);
  }
  override IData dup() {
    return DoubleValue(attribute, toJson);
  }

  double toDouble() { 
    if (isNull) return 0; 
    return _value; }

  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(_value); }

  override string toString() { 
    if (isNull) return "0"; 
    return to!string(_value); }
}
mixin(ValueCalls!("DoubleValue", "double"));  

version(test_uim_models) { unittest {    
  assert(DoubleValue.value("100").toDouble == 100);
  assert(DoubleValue.value(Json(100)).toDouble == 100);
  assert(DoubleValue.value("200").toDouble != 100);
  assert(DoubleValue.value(Json(200)).toDouble != 100);

  assert(DoubleValue.value("100").toString == "100");
  assert(DoubleValue.value(Json(100)).toString == "100");
  assert(DoubleValue.value("200").toString != "100");
  assert(DoubleValue.value(Json(200)).toString != "100");

  assert(DoubleValue.value("100").toJson == Json(100));
  assert(DoubleValue.value(Json(100)).toJson == Json(100));
  assert(DoubleValue.value("200").toJson != Json(100));
  assert(DoubleValue.value(Json(200)).toJson != Json(100));
}} 

///
unittest {
  auto boolValue = new DBooleanValue(true);
  assert(boolValue == true);
  assert(boolValue != false);
}