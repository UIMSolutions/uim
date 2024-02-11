/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.calenderparts.month;

/* any <- integer <- integerCalendarPart <- month
Traits
is.dataFormat.integer
means.calendar
means.calendar.month */

import uim.models;

@safe:

/* means.calendar
means.calendar.day */
class DMonthpartAttribute : DIntegerCalendarPart {
  mixin(AttributeThis!("MonthpartAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    name("monthpart");
    registerPath("monthpart");

    return true;

  }
}

mixin(AttributeCalls!("MonthpartAttribute"));

version (test_uim_models) {
  unittest {
    testAttribute(new DMonthpartAttribute);
    testAttribute(MonthpartAttribute);
  }
}
