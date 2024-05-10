/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.inches;

/* Inheritance
any <- float <- double <- inches
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.distance.inches */

import uim.models;

@safe:
class DInchesAttribute : DDoubleAttribute {
  mixin(AttributeThis!("Inches"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("inches");
    registerPath("inches");

    return true;
  }
}

mixin(AttributeCalls!("Inches"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
