/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.datatypes.datetimes.time_;

import uim.models;

@safe:
class DTimeData : DData {
  mixin(DataThis!("TimeData", "TimeOfDay"));  

  protected TimeOfDay _value;  
  TimeOfDay value() {
    return _value; 
  }
  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    isTime(true);

    return true;
  }

  // Hooks for setting 
  void set(TimeOfDay newValue) {
    _value = newValue; 
  }  

  override void set(string newValue) {
    if (newValue.isNull) { 
        isNull(isNullable ? true : false);
        set(TimeOfDay()); }
    else {
        isNull(false);
        // set(fromISOExtString(newValue)); 
    }
  }  

  override void set(Json newValue) {
    if (newValue.isEmpty) { 
      _value = TimeOfDay(); 
      isNull(isNullable ? true : false); }
    else {
      set(newValue.get!string);
      isNull(false);
    }
  }

  alias opEquals = Object.opEquals;
  alias opEquals = DData.opEquals;

  override IData clone() {
    return TimeData; // TODO (attribute, toJson);
  }

  alias opEquals = Object.opEquals;

alias toJson = DData.toJson;
  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(get.toISOExtString); }

  override string toString() { 
    if (isNull) return null; 
    return get.toISOExtString; }
}
mixin(DataCalls!("TimeData", "TimeOfDay"));  

unittest {   
  /*  
    assert(TimeData.set("100").toTime == 100);
    assert(TimeData.set(Json(100)).toTime == 100);
    assert(TimeData.set("200").toTime != 100);
    assert(TimeData.set(Json(200)).toTime != 100);

    assert(TimeData.set("100").toString == "100");
    assert(TimeData.set(Json(100)).toString == "100");
    assert(TimeData.set("200").toString != "100");
    assert(TimeData.set(Json(200)).toString != "100");

    assert(TimeData.set("100").toJson == Json(100));
    assert(TimeData.set(Json(100)).toJson == Json(100));
    assert(TimeData.set("200").toJson != Json(100));
    assert(TimeData.set(Json(200)).toJson != Json(100));
    */
}