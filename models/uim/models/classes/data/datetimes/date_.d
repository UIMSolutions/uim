/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.datetimes.date_;

import uim.models;
@safe:
import std.datetime.date;

class DDateData : DData {
  mixin(DataThis!("DateValue", "Date"));  

  protected Date _value;  
  alias value = DData.value;
  void value(this O)(Date newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  Date value() {
    return _value; 
  }
  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }

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

  override IData copy() {
    return DateValue(attribute, toJson);
  }
  override IData dup() {
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