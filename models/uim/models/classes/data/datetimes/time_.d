/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.values.datetimes.time_;

import uim.models;

@safe:
class DTimeData: DData {
  mixin(DataThis!("TimeValue", "TimeOfDay"));  

  protected TimeOfDay _value;  
  alias value = DData.value;
  O value(this O)(TimeOfDay newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  TimeOfDay value() {
    return _value; 
  }
  // Initialization hook method.
  override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

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

  override DData copy() {
    return TimeValue(attribute, toJson);
  }
  override DData dup() {
    return copy;
  }

  alias opEquals = Object.opEquals;

  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(this.value.toISOExtString); }

  override string toString() { 
    if (isNull) return null; 
    return this.value.toISOExtString; }
}
mixin(ValueCalls!("TimeValue", "TimeOfDay"));  

version(test_uim_models) { unittest {    
    assert(TimeValue.value("100").toTime == 100);
    assert(TimeValue.value(Json(100)).toTime == 100);
    assert(TimeValue.value("200").toTime != 100);
    assert(TimeValue.value(Json(200)).toTime != 100);

    assert(TimeValue.value("100").toString == "100");
    assert(TimeValue.value(Json(100)).toString == "100");
    assert(TimeValue.value("200").toString != "100");
    assert(TimeValue.value(Json(200)).toString != "100");

    assert(TimeValue.value("100").toJson == Json(100));
    assert(TimeValue.value(Json(100)).toJson == Json(100));
    assert(TimeValue.value("200").toJson != Json(100));
    assert(TimeValue.value(Json(200)).toJson != Json(100));
}} 