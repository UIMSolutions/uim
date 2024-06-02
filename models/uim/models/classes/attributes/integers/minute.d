/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.minute;

/* Unit of measure for time in 60 second interval

Inheritance
any <- integer <- minute
Traits
is.dataFormat.integer
means.measurement.dimension.time
means.measurement.duration.minutes
has.measurement.fundamentalComponent.second */

import uim.models;

@safe:
class DMinuteAttribute : DIntegerAttribute {
  mixin(AttributeThis!("Minute"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("minute");
    registerPath("minute");

    return true;

  }    
}
mixin(AttributeCalls!("Minute"));

version(test_uim_models) { unittest {
    testAttribute(new DMinuteAttribute);
    testAttribute(MinuteAttribute);
  }
}