/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.datetimes.datetimeoffset;

import uim.models;

@safe:
class DDatetimeOffsetAttribute : DDatetimeAttribute {
  mixin(AttributeThis!("DatetimeOffset"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    
      addDataFormats(["timeOffset"]);
      name("datetimeOffset");
      registerPath("datetimeOffset");
        /* means.measurement.date
        means.measurement.time
        is.dataFormat.timeOffset */
        
      return true; 
  }
}
mixin(AttributeCalls!"DatetimeOffset");

version(test_uim_models) { unittest {
    testAttribute(new DDatetimeOffsetAttribute);
    testAttribute(DatetimeOffsetAttribute);
  }
}