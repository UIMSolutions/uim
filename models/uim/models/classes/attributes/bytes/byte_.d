/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.bytes.byte_;

import uim.models;

@safe:
class DByteAttribute : DAttribute {
  mixin(AttributeThis!("ByteAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .addDataFormats(["byte"])
      .name("byte")
      .registerPath("byte");
  }
}
mixin(AttributeCalls!("ByteAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DByteAttribute);
    testAttribute(ByteAttribute);
  }
}