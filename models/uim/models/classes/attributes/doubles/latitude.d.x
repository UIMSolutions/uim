/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.latitude;

import uim.models;

@safe:

// means.location.latitude
class DLatitudeAttribute : DDoubleAttribute {
  mixin(AttributeThis!("LatitudeAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("latitude");
    registerPath("latitude");

    return true;
  }
}

mixin(AttributeCalls!("LatitudeAttribute"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
