/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.dates.date_;

import uim.models;

@safe:
class DDateAttribute : DAttribute {
  mixin(AttributeThis!("Date"));

  // Initialization hook method.  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }
    // means.measurement.date

    name("date");
    dataFormats(["date"]);
    registerPath("date");

    return true;
  }

  /* override Json createData() {
    return DateData(this); } */
}

mixin(AttributeCalls!("Date"));

version (test_uim_models) {
  unittest {
    // TODO tests
  }
}
