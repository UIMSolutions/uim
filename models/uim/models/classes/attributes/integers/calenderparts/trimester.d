/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.calenderparts.trimester;

/* any <- integer <- integerCalendarPart <- trimester
Traits
is.dataFormat.integer
means.calendar
means.calendar.trimester */

import uim.models;

@safe:
class DTrimesterAttribute : DIntegerCalendarPart {
  mixin(AttributeThis!("Trimester"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("trimester");
    registerPath("trimester");

    return true;
  }
}

mixin(AttributeCalls!("Trimester"));

version (test_uim_models) {
  unittest {
    testAttribute(new DTrimesterAttribute);
    testAttribute(TrimesterAttribute);
  }
}
