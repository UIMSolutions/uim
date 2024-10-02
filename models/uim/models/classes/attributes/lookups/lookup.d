/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.lookups.lookup;    

import uim.models;

@safe:
class DLookupAttribute : DAttribute {
  mixin(AttributeThis!("Lookup"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; } 
    // means.measurement.lookup

    name("lookup");
    dataFormats(["lookup"]);
    registerPath("lookup");

    return true;
  }

  /* override Json createData() {
    return LookupData(this); 
  } */
}
mixin(AttributeCalls!("Lookup"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}