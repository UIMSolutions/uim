/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.datetimes.datetime;

import uim.models;

@safe:
class DDatetimeAttribute : DDateAttribute {
  mixin(AttributeThis!("Datetime"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    addDataFormats(["time"]);
    name("datetime");
    registerPath("datetime");
    // means.measurement.date
    // means.measurement.time

    return true;
  }

  /* override Json createData() {
    return DatetimeData(this); } */
}

mixin(AttributeCalls!"Datetime");

version (test_uim_models) {
  unittest {
    testAttribute(new DDatetimeAttribute);
    testAttribute(DatetimeAttribute);
  }
}
