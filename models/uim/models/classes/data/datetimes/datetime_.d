/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.datetimes.datetime_;

import uim.models;

@safe:
class DDatetimeData : DData {
  mixin(DataThis!("DatetimeData", "DateTime"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    isDatetime(true);

    return true;
  }

  protected DateTime _value;
  DateTime get() {
    return _value;
  }
  
  // Hooks for setting 
  void set(DateTime newValue) {
    _value = newValue;
  }

  override void set(string newValue) {
    if (newValue is null) {
      this.isNull(isNullable ? true : false);
      set(DateTime());
    } else {
      this.isNull(false);
      set(DateTime.fromISOExtString(newValue));
    }
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      set(DateTime());
      isNull(isNullable ? true : false);
    } else {
      set(newValue.get!string);
      isNull(false);
    }
  }

  override IData clone() {
    return DatetimeData(attribute, toJson);
  }

  alias toJson = DData.toJson;
  override Json toJson() {
    if (isNull)
      return Json(null);
    return Json(this.value.toISOExtString);
  }

  override string toString() {
    if (isNull)
      return null;
    return this.value.toISOExtString;
  }
}

mixin(DataCalls!("DatetimeData", "DateTime"));

unittest {
  // TODO
  /*
  assert(DatetimeData.value("100").toDatetime == 100);
  assert(DatetimeData.value(Json(100)).toDatetime == 100);
  assert(DatetimeData.value("200").toDatetime != 100);
  assert(DatetimeData.value(Json(200)).toDatetime != 100);

  assert(DatetimeData.value("100").toString == "100");
  assert(DatetimeData.value(Json(100)).toString == "100");
  assert(DatetimeData.value("200").toString != "100");
  assert(DatetimeData.value(Json(200)).toString != "100");

  assert(DatetimeData.value("100").toJson == Json(100));
  assert(DatetimeData.value(Json(100)).toJson == Json(100));
  assert(DatetimeData.value("200").toJson != Json(100));
  assert(DatetimeData.value(Json(200)).toJson != Json(100));
  */
}
