/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.codes.status;

import uim.models;

@safe:
class DStatusCodeAttribute : DIntegerStringAttribute {
  mixin(AttributeThis!("StatusCode"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("statusCode");
    display("Status Reason");
    lookups([
        0: "Active",
        1: "Inactive"
      ]);
    isNullable(true);
    registerPath("statuscode");

    return true;
  }
}

mixin(AttributeCalls!("StatusCode"));

version (test_uim_models) {
  unittest {
    // TODO tests
  }
}
