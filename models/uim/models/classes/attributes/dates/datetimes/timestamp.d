/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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
    super.initialize(configData);

    this
      .dataFormats(["timestamp"])
      .name("timestamp")
      .registerPath("timestamp");
  }
  override IData createValue() {
    return TimestampValue(this); }
}
mixin(AttributeCalls!"TimestampAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DTimestampAttribute);
    testAttribute(TimestampAttribute);
  }
}