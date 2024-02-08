/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("quarter")
      .registerPath("quarter");
  }
}
mixin(AttributeCalls!("QuarterAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DQuarterAttribute);
    testAttribute(QuarterAttribute);
  }
}