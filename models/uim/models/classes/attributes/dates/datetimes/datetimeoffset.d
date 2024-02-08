/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.dates.datetimes.datetimeoffset;

import uim.models;

@safe:
class DDatetimeOffsetAttribute : DDatetimeAttribute {
  mixin(AttributeThis!("DatetimeOffsetAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .addDataFormats(["timeOffset"])
      .name("datetimeOffset")
      .registerPath("datetimeOffset");
        /* means.measurement.date
        means.measurement.time
        is.dataFormat.timeOffset */
  }
}
mixin(AttributeCalls!"DatetimeOffsetAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DDatetimeOffsetAttribute);
    testAttribute(DatetimeOffsetAttribute);
  }
}