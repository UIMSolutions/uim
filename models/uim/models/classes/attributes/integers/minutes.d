/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.minutes;

/* any <- integer <- minutes <- minutess
Traits
is.dataFormat.integer
means.measurement.dimension.time
means.measurement.duration.minutes
has.measurement.fundamentalComponent.second */

import uim.models;

@safe:
class DMinutesAttribute : DIntegerAttribute {
  mixin(AttributeThis!("Minutes"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }
    name("minutes");
    registerPath("minutes");

    return true;
  }    
}
mixin(AttributeCalls!("Minutes"));

version(test_uim_models) { unittest {
    testAttribute(new DMinutesAttribute);
    testAttribute(MinutesAttribute);
  }
}