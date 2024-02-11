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
  mixin(DataThis!("DateData", "Date"));

  protected Date _value;
  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    isDate(true);

    return true;
  }

  void set(Date newValue) {
    _value = newValue;
  }
  Date get() {
    return _value;
  }

  override void set(string newValue) {
    _value = Date.fromISOExtString(newValue);
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      value(Date());
      isNull(isNullable ? true : false);
    } else {
      value(newValue.get!string);
      isNull(false);
    }
  }

  override IData clone() {
    return DateData(attribute, toJson);
  }
alias toJson = DData.toJson;
  override Json toJson() {
    if (isNull)
      return Json(null);
    auto json = Json.emptyObject;
    return Json(get.toISOExtString);
  }

  override string toString() {
    if (isNull)
      return null;
    return get.toISOExtString;
  }
}

mixin(DataCalls!("DateData", "Date"));

  unittest {
    /* 
    assert(DateData.set("100").toDate == 100);
    assert(DateData.set(Json(100)).toDate == 100);
    assert(DateData.set("200").toDate != 100);
    assert(DateData.set(Json(200)).toDate != 100);

    assert(DateData.set("100").toString == "100");
    assert(DateData.set(Json(100)).toString == "100");
    assert(DateData.set("200").toString != "100");
    assert(DateData.set(Json(200)).toString != "100");

    assert(DateData.set("100").toJson == Json(100));
    assert(DateData.set(Json(100)).toJson == Json(100));
    assert(DateData.set("200").toJson != Json(100));
    assert(DateData.set(Json(200)).toJson != Json(100)); */
}
