/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.long_;

import uim.models;

@safe:
class DLongAttribute : DAttribute {
  mixin(AttributeThis!("LongAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .addDataFormats(["long"])
      .name("long")
      .registerPath("long");
  }    
}
mixin(AttributeCalls!("LongAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DLongAttribute);
    testAttribute(LongAttribute);
  }
}