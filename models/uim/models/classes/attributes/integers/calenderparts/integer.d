/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.calenderparts.integer;

import uim.models;

@safe:
class DIntegerCalendarPart : DIntegerAttribute {
  mixin(AttributeThis!"IntegerCalendarPart");

  /* means.calendar
means.calendar.day
 */ // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("integerCalendarPart");
    registerPath("integerCalendarPart");

    return true;
  }
}

mixin(AttributeCalls!"IntegerCalendarPart");

version (test_uim_models) {
  unittest {
    testAttribute(new DIntegerCalendarPart);
    testAttribute(IntegerCalendarPart);
  }
}
