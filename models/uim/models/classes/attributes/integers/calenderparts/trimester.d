/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
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
  mixin(AttributeThis!("TrimesterAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .name("trimester")
      .registerPath("trimester");
  }
}
mixin(AttributeCalls!("TrimesterAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DTrimesterAttribute);
    testAttribute(TrimesterAttribute);
  }
}