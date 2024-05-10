/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.longitude;

/* any <- float <- double <- longitude
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.location.longitude */

import uim.models;

@safe:
class DLongitudeAttribute : DDoubleAttribute {
  mixin(AttributeThis!("Longitude"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("longitude");
    registerPath("longitude");

    return true;
  }
}

mixin(AttributeCalls!("Longitude"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
