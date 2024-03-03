/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.calenderparts.quarter;

/* any <- integer <- integerCalendarPart <- quarter
Traits
is.dataFormat.integer
means.calendar
means.calendar.quarter */

import uim.models;

@safe:
class DQuarterAttribute : DIntegerCalendarPart {
  mixin(AttributeThis!("QuarterAttribute"));

  // Initialization hook method.
  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("quarter");
    registerPath("quarter");

    return true;
  }
}

mixin(AttributeCalls!("QuarterAttribute"));

version (test_uim_models) {
  unittest {
    testAttribute(new DQuarterAttribute);
    testAttribute(QuarterAttribute);
  }
}
