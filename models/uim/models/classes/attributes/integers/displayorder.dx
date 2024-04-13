/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.displayorder;

import uim.models;

@safe:
class DDisplayOrderAttribute : DIntegerAttribute {
  mixin(AttributeThis!("DisplayOrder"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("displayOrder");
    registerPath("displayOrder");

    return true;
  }
}

mixin(AttributeCalls!("DisplayOrder"));

version (test_uim_models) {
  unittest {
    testAttribute(new DDisplayOrderAttribute);
    testAttribute(DisplayOrderAttribute);
  }
}
