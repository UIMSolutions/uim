/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.datetimes.timestamp;

import uim.models;

@safe:
class DTimestampAttribute : DLongAttribute {
  mixin(AttributeThis!("TimestampAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .dataFormats(["timestamp"])
      .name("timestamp")
      .registerPath("timestamp");

    return true;
  }
  /* override IData createData() {
    return TimestampValue(this); } */
}
mixin(AttributeCalls!"TimestampAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DTimestampAttribute);
    testAttribute(TimestampAttribute);
  }
}