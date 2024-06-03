/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.calenderparts.tenday;

/* any <- integer <- integerCalendarPart <- tenday
Traits
is.dataFormat.integer
means.calendar
means.calendar.tenday */

import uim.models;

@safe:
class DTendayAttribute : DIntegerCalendarPartAttribute {
  mixin(AttributeThis!("Tenday"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("tenday");
    registerPath("tenday");

    return true;

  }
}
mixin(AttributeCalls!("Tenday"));

version(test_uim_models) { unittest {
    testAttribute(new DTendayAttribute);
    testAttribute(TendayAttribute);
  }
}