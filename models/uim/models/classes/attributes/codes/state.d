/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.codes.state;

import uim.models;

@safe:
class DStateCodeAttribute : DIntegerStringAttribute {
  mixin(AttributeThis!("StateCode"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    
      name("stateCode");
      display("Status Reason");
      lookups([
        0: "Active",  
        1: "Inactive"
      ]);
      isNullable(true);
      registerPath("statecode");

    return true;
  }
}
mixin(AttributeCalls!("StateCode"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}