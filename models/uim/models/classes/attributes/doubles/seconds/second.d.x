/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.seconds.second;

/* Unit of measure for time in seconds

Inheritance
any <- float <- double <- second
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.time
means.measurement.units.si.second
has.measurement.fundamentalComponent.second
means.measurement.duration.seconds */

import uim.models;

@safe:
class DSecondAttribute : DDoubleAttribute {
  mixin(AttributeThis!("SecondAttribute"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("second");
    registerPath("second");

    return true;
  }
}
mixin(AttributeCalls!("SecondAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}