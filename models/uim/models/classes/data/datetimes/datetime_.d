/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.datetimes.datetime_;

import uim.models;

@safe:
class DDatetimeData : DData {
  mixin(DataThis!("DatetimeValue", "DateTime"));  

  protected DateTime _value;  
  alias value = DData.value;
  void value(this O)(DateTime newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  DateTime value() {
    return _value; 
  }
  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .isDatetime(true);
  }

  // Hooks for setting 
  protected void set(DateTime newValue) {
    _value = newValue; 
  }  

  override protected void set(string newValue) {
    if (newValue is null) { 
      this.isNull(isNullable ? true : false); 
      this.value(DateTime()); }
    else {
      this.isNull(false);
      this.value(DateTime.fromISOExtString(newValue)); 
    }
  }  

  override protected void set(Json newValue) {
    if (newValue.isEmpty) { 
      _value = DateTime(); 
      this.isNull(isNullable ? true : false); }
    else {
      this
        .value(newValue.get!string)
        .isNull(false);
    }
  }

  override IData copy() {
    return DatetimeValue(attribute, toJson);
  }
  override IData dup() {
    return copy;
  }

  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(this.value.toISOExtString); }

  override string toString() { 
    if (isNull) return null; 
    return this.value.toISOExtString; }
}
mixin(ValueCalls!("DatetimeValue", "DateTime"));  

version(test_uim_models) { unittest {    
    assert(DatetimeValue.value("100").toDatetime == 100);
    assert(DatetimeValue.value(Json(100)).toDatetime == 100);
    assert(DatetimeValue.value("200").toDatetime != 100);
    assert(DatetimeValue.value(Json(200)).toDatetime != 100);

    assert(DatetimeValue.value("100").toString == "100");
    assert(DatetimeValue.value(Json(100)).toString == "100");
    assert(DatetimeValue.value("200").toString != "100");
    assert(DatetimeValue.value(Json(200)).toString != "100");

    assert(DatetimeValue.value("100").toJson == Json(100));
    assert(DatetimeValue.value(Json(100)).toJson == Json(100));
    assert(DatetimeValue.value("200").toJson != Json(100));
    assert(DatetimeValue.value(Json(200)).toJson != Json(100));
}} 