/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.null_;

import uim.models;

@safe:
class DNullData : DData {
  mixin(DataThis!("NullValue"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .isNull(true);
  }

  override IData copy() {
    return NullValue;
  }

  override IData dup() {
    return NullValue;
  }

  override Json toJson() {
    return Json(null);
  }

  override string toString() {
    return null;
  }
}

mixin(ValueCalls!("NullValue"));
