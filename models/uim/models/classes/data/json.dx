/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.data.json;

import uim.models;

@safe:
class DJsonData : DData {
  mixin(DataThis!("Json"));

  protected Json _value;

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    set(Json.emptyObject);
    //     this.value(parseJsonString(newValue));
    isObject(true);

    return true;
  }

  override IData clone() {
    return new DJsonData; // TODO (attribute, toJson);
  }

  alias toJson = DData.toJson;
  override Json toJson() {
    if (isNull)
      return Json(null);
    return _value;
  }

  override string toString() {
    if (isNull)
      return null;
    return _value.toString;
  }
}

mixin(DataCalls!("Json"));
