/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.datetimes.time_;

import uim.models;

@safe:
class DTimeData : DData {
  mixin(DataThis!("TimeData", "TimeOfDay"));  

  protected TimeOfDay _value;  
  alias value = DData.value;
  void value(this O)(TimeOfDay newValue) {
    this.set(newValue);
     
  }
  TimeOfDay value() {
    return _value; 
  }
  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .isTime(true);
  }

  // Hooks for setting 
  protected void set(TimeOfDay newValue) {
    _value = newValue; 
  }  

  override protected void set(string newValue) {
    if (newValue is null) { 
      this
        .isNull(isNullable ? true : false) 
        .value(TimeOfDay()); }
    else {
      this
        .isNull(false);
        // .value(fromISOExtString(newValue)); 
    }
  }  

  override protected void set(Json newValue) {
    if (newValue.isEmpty) { 
      _value = TimeOfDay(); 
      this.isNull(isNullable ? true : false); }
    else {
      // _value = newValue.get!string.fromISOExtString;
      this.isNull(false);
    }
  }

  alias opEquals = Object.opEquals;
  alias opEquals = DData.opEquals;

  override IData clone() {
    return TimeData(attribute, toJson);
  }

  alias opEquals = Object.opEquals;

  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(this.value.toISOExtString); }

  override string toString() { 
    if (isNull) return null; 
    return this.value.toISOExtString; }
}
mixin(ValueCalls!("TimeData", "TimeOfDay"));  

version(test_uim_models) { unittest {    
    assert(TimeData.value("100").toTime == 100);
    assert(TimeData.value(Json(100)).toTime == 100);
    assert(TimeData.value("200").toTime != 100);
    assert(TimeData.value(Json(200)).toTime != 100);

    assert(TimeData.value("100").toString == "100");
    assert(TimeData.value(Json(100)).toString == "100");
    assert(TimeData.value("200").toString != "100");
    assert(TimeData.value(Json(200)).toString != "100");

    assert(TimeData.value("100").toJson == Json(100));
    assert(TimeData.value(Json(100)).toJson == Json(100));
    assert(TimeData.value("200").toJson != Json(100));
    assert(TimeData.value(Json(200)).toJson != Json(100));
}} 