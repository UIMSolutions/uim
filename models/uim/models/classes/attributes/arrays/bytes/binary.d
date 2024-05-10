/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.arrays.bytes.binary;

import uim.models;

@safe:
class DBinaryAttribute : DAttribute {
  mixin(AttributeThis!("Binary"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    /* Inheritance
    any <- byte <- binary
    Traits
    is.dataFormat.byte
    is.dataFormat.array */

    addDataFormats(["array"]);
    name("binary");
    registerPath("binary");

    return true;
  }
}

mixin(AttributeCalls!("Binary"));

version (test_uim_models) {
  unittest {
    testAttribute(new DBinaryAttribute);
    testAttribute(BinaryAttribute);
  }
}
