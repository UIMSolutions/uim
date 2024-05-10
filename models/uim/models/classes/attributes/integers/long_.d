/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.long_;

import uim.models;

@safe:
class DLongAttribute : DAttribute {
  mixin(AttributeThis!("Long"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    addDataFormats(["long"]);
    name("long");
    registerPath("long");

    return true;
  }    
}
mixin(AttributeCalls!("Long"));

version(test_uim_models) { unittest {
    testAttribute(new DLongAttribute);
    testAttribute(LongAttribute);
  }
}