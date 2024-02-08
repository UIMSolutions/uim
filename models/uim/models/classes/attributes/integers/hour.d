/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.hour;

/* Unit of measure for time in 3600 second interval

means.measurement.dimension.time
means.measurement.duration.hours
has.measurement.fundamentalComponent.second */

import uim.models;

@safe:
class DHourAttribute : DIntegerAttribute {
  mixin(AttributeThis!("HourAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    name("hour");
    registerPath("hour");

    return true;

  }
}

mixin(AttributeCalls!("HourAttribute"));

version (test_uim_models) {
  unittest {
    testAttribute(new DHourAttribute);
    testAttribute(HourAttribute);
  }
}
