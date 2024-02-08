/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.values.datetimes.date_;

import uim.models;
@safe:
import std.datetime.date;

class DDateValue : DValue {
  mixin(ValueThis!("DateValue", "Date"));  

  protected Date _value;  
  alias value = DValue.value;
  O value(this O)(Date newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  Date value() {
    return _value; 
  }
  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isDate(true);
  }

  void set(Date newValue) {
    _value = newValue;
  }
  override void set(string newValue) {
    _value = Date.fromISOExtString(newValue);
  }
  override void set(Json newValue) {
    if (newValue.isEmpty) { 
      this
        .value(Date()) 
        .isNull(isNullable ? true : false); }
    else {
      this
        .value(newValue.get!string)
        .isNull(false);
    }
  }

  override DValue copy() {
    return DateValue(attribute, toJson);
  }
  override DValue dup() {
    return copy;
  }

  override Json toJson() { 
    if (isNull) return Json(null);
    auto json = Json.emptyObject;
    return Json(this.value.toISOExtString); }

  override string toString() { 
    if (isNull) return null; 
    return this.value.toISOExtString; }
}
mixin(ValueCalls!("DateValue", "Date"));  

version(test_uim_models) { unittest {    
    assert(DateValue.value("100").toDate == 100);
    assert(DateValue.value(Json(100)).toDate == 100);
    assert(DateValue.value("200").toDate != 100);
    assert(DateValue.value(Json(200)).toDate != 100);

    assert(DateValue.value("100").toString == "100");
    assert(DateValue.value(Json(100)).toString == "100");
    assert(DateValue.value("200").toString != "100");
    assert(DateValue.value(Json(200)).toString != "100");

    assert(DateValue.value("100").toJson == Json(100));
    assert(DateValue.value(Json(100)).toJson == Json(100));
    assert(DateValue.value("200").toJson != Json(100));
    assert(DateValue.value(Json(200)).toJson != Json(100));
}} 