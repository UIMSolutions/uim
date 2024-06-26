/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.data.datetimes.systime;

import uim.models;

@safe:

class DSystimeData : DData {
  mixin(DataThis!("Systime"));

  protected ISysTime _value;

  SysTime value() {
    return _value;
  }
  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isTimestamp(true);

    return true;
  }

  // Hooks for setting 
  void set(SysTime newValue) {
    _value = newValue;
  }

  override void set(string newValue) {
    if (newValue.isNull) {
      isNull(isNullable ? true : false);
      set(SysTime());
    } else {
      isNull(false);
      // set(fromISOExtString(newValue)); 
    }

    alias opEquals = DData.opEquals;
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      set(SysTime());
      isNull(isNullable ? true : false);
    } else {
      // set(newValue.get!string.fromISOExtString);
      isNull(false);
    }
  }

  override IData clone() {
    return SystimeData; // TODO (attribute, toJson);
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

mixin(DataCalls!("Systime"));

unittest {
  // TODO
}
