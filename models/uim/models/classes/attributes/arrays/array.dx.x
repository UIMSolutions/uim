/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.arrays.array;

import uim.models;

@safe:
class DArrayAttribute : DAttribute {
  mixin(AttributeThis!("ArrayAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    name("arrayAttribute");
    addDataFormats(["array"]);
    registerPath("arrayAttribute");

    return true;
  }
}

mixin(AttributeCalls!"ArrayAttribute");

version (test_uim_models) {
  unittest {
    testAttribute(new DArrayAttribute);
    testAttribute(ArrayAttribute);
  }
}
