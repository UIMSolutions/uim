/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.datetimes.timestamp;

import uim.models;

@safe:
class DTimestampAttribute : DLongAttribute {
  mixin(AttributeThis!("Timestamp"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    
      dataFormats(["timestamp"]);
      registerPath("atributes.timestamp");

    return true;
  }
  /* override Json createData() {
    return TimestampData(this); } */
}
mixin(AttributeCalls!"Timestamp");

// TODO
unittest {
    testAttribute(new DTimestampAttribute);
    testAttribute(TimestampAttribute);
}