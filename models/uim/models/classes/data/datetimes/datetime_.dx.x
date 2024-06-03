/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.data.datetimes.datetime_;

import uim.models;

@safe:
class DDatetimeData : DData {
  mixin(DataThis!("Datetime"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isDatetime(true);

    return true;
  }

  protected DateTime _value;
  DateTime value() {
    return _value;
  }
  
  // Hooks for setting 
  void set(DateTime newValue) {
    _value = newValue;
  }

  override void set(string newValue) {
    if (newValue.isNull) {
      isNull(isNullable ? true : false);
      set(DateTime());
    } else {
      isNull(false);
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
    return DatetimeData; // TODO (attribute, toJson);
  }

  alias toJson = DData.toJson;
  override Json toJson() {
    if (isNull)
      return Json(null);
    return Json(get.toISOExtString);
  }

  override string toString() {
    if (isNull)
      return null;
    return get.toISOExtString;
  }
}

mixin(DataCalls!("Datetime"));

unittest {
  // TODO
  /*
  assert(DatetimeData.set("100").toDatetime == 100);
  assert(DatetimeData.set(Json(100)).toDatetime == 100);
  assert(DatetimeData.set("200").toDatetime != 100);
  assert(DatetimeData.set(Json(200)).toDatetime != 100);

  assert(DatetimeData.set("100").toString == "100");
  assert(DatetimeData.set(Json(100)).toString == "100");
  assert(DatetimeData.set("200").toString != "100");
  assert(DatetimeData.set(Json(200)).toString != "100");

  assert(DatetimeData.set("100").toJson == Json(100));
  assert(DatetimeData.set(Json(100)).toJson == Json(100));
  assert(DatetimeData.set("200").toJson != Json(100));
  assert(DatetimeData.set(Json(200)).toJson != Json(100));
  */
}
