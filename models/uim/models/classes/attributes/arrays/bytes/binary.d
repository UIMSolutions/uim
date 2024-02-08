/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.arrays.bytes.binary;

import uim.models;

@safe:
class DBinaryAttribute : DAttribute {
  mixin(AttributeThis!("BinaryAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);


    /* Inheritance
    any <- byte <- binary
    Traits
    is.dataFormat.byte
    is.dataFormat.array */
    this
      .addDataFormats(["array"])
      .name("binary")
      .registerPath("binary");
  }
}
mixin(AttributeCalls!("BinaryAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DBinaryAttribute);
    testAttribute(BinaryAttribute);
  }
}