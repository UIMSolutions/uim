/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module models.uim.models.classes.attributes.arrays.array;

import uim.models;

@safe:
class DArrayAttribute : DAttribute {
  mixin(AttributeThis!("Array"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("arrayAttribute");
    addDataFormats(["array"]);
    registerPath("arrayAttribute");

    return true;
  }
}

mixin(AttributeCalls!"Array");

version (test_uim_models) {
  unittest {
    testAttribute(new DArrayAttribute);
    testAttribute(ArrayAttribute);
  }
}
