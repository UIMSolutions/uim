/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.calenderparts.day;

import uim.models;

@safe:

/* means.calendar
means.calendar.day */
class DDayPartAttribute : DIntegerCalendarPart {
  mixin(AttributeThis!("DayPart"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("daypart");
    registerPath("daypart");

    return true;
  }
}

mixin(AttributeCalls!("DayPart"));

version (test_uim_models) {
  unittest {
    testAttribute(new DDayPartAttribute);
    testAttribute(DayPartAttribute);
  }
}
