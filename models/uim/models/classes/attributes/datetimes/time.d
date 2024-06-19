/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.datetimes.time;

import uim.models;

@safe:
class DTimeAttribute : DAttribute {
  mixin(AttributeThis!("Time"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }
    
      dataFormats(["time"]);
      registerPath("attributes.time");
      // means.measurement.date
      // means.measurement.time

    return true;
  }
  
  /* override Json createData() {
    return TimeData(this); } */
}
mixin(AttributeCalls!"Time");

// TODOD
unittest {
    testAttribute(new DTimeAttribute);
    testAttribute(TimeAttribute);
  }