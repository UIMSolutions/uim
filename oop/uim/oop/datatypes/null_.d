/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.datatypes.null_;

import uim.oop;

@safe:
class DNullData : DData {
  mixin(DataThis!("Null"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isNull(true);

    return true;
  }

  override IData clone() {
    return NullData;
  }

  alias toJson = DData.toJson;
  override Json toJson() {
    return Json(null);
  }

  override string toString() {
    return null;
  }
}

mixin(DataCalls!("Null"));
