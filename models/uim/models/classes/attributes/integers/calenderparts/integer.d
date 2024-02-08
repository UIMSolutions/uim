/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.calenderparts.integer;

import uim.models;

@safe:
class DIntegerCalendarPart : DIntegerAttribute {
  mixin(AttributeThis!"IntegerCalendarPart");

/* means.calendar
means.calendar.day
 */  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("integerCalendarPart")
      .registerPath("integerCalendarPart");
  }    
}
mixin(AttributeCalls!"IntegerCalendarPart");

version(test_uim_models) { unittest {
    testAttribute(new DIntegerCalendarPart);
    testAttribute(IntegerCalendarPart);
  }
}