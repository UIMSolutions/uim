/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.bytes.byte_;

import uim.models;

@safe:
class DByteAttribute : DAttribute {
  mixin(AttributeThis!("ByteAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    addDataFormats(["byte"]);
    name("byte");
    registerPath("byte");

    return true;
  }
}

mixin(AttributeCalls!("ByteAttribute"));

version (test_uim_models) {
  unittest {
    testAttribute(new DByteAttribute);
    testAttribute(ByteAttribute);
  }
}
