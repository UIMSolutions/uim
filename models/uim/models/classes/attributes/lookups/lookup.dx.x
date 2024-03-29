/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.lookup;

import uim.models;

@safe:
class DLookupAttribute : DAttribute {
  mixin(AttributeThis!("LookupAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; } 
    // means.measurement.lookup

    name("lookup");
    dataFormats(["lookup"]);
    registerPath("lookup");

    return true;
  }

  /* override IData createData() {
    return LookupData(this); 
  } */
}
mixin(AttributeCalls!("LookupAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}