/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.calenderparts.week;

/* any <- integer <- integerCalendarPart <- week
Traits
is.dataFormat.integer
means.calendar
means.calendar.week */

import uim.models;

@safe:
class DWeekAttribute : DIntegerCalendarPart {
  mixin(AttributeThis!("Week"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("week");
    registerPath("week");

    return true;
  }
}

mixin(AttributeCalls!("Week"));

version (test_uim_models) {
  unittest {
    testAttribute(new DWeekAttribute);
    testAttribute(WeekAttribute);
  }
}
