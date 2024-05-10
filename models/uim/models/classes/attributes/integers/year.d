/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.year;

/* Unit of measure for time in 'one solar orbit' interval

Inheritance
any <- integer <- year
Traits
is.dataFormat.integer
means.measurement.dimension.time
means.measurement.duration.years
has.measurement.fundamentalComponent.second */

import uim.models;

@safe:
class DYearAttribute : DIntegerAttribute {
  mixin(AttributeThis!("Year"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("year");
    registerPath("year");

    return true;
  }
}

mixin(AttributeCalls!("Year"));

version (test_uim_models) {
  unittest {
    testAttribute(new DYearAttribute);
    testAttribute(YearAttribute);
  }
}
