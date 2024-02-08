/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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
  mixin(AttributeThis!("WeekAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("week")
      .registerPath("week");
  }
}
mixin(AttributeCalls!("WeekAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DWeekAttribute);
    testAttribute(WeekAttribute);
  }
}