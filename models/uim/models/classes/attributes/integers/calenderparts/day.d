/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.calenderparts.day;

import uim.models;
@safe:

/* means.calendar
means.calendar.day */
class DDayPartAttribute : DIntegerCalendarPart {
  mixin(AttributeThis!("DayPartAttribute"));

override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("daypart")
      .registerPath("daypart");
  }   
}
mixin(AttributeCalls!("DayPartAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DDayPartAttribute);
    testAttribute(DayPartAttribute);
  }
}