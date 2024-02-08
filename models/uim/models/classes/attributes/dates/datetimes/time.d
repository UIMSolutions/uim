/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.datetimes.time;

import uim.models;

@safe:
class DTimeAttribute : DAttribute {
  mixin(AttributeThis!("TimeAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }

    this
      .dataFormats(["time"])
      .name("time")
      .registerPath("time");
      // means.measurement.date
      // means.measurement.time
  }
  override IData createValue() {
    return TimeValue(this); }
}
mixin(AttributeCalls!"TimeAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DTimeAttribute);
    testAttribute(TimeAttribute);
  }
}