/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module models.uim.models.classes.attributes.doubles.percentage;

import uim.models;

@safe:
class DPercentageAttribute : DDoubleAttribute {
  mixin(AttributeThis!("Percentage"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("percentage");
    registerPath("percentage");

    return true;
  }
}

mixin(AttributeCalls!("Percentage"));

version (test_uim_models) {
  unittest {
    // TODO tests
  }
}
