/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.chars.char_;

import uim.models;

@safe:
class DCharAttribute : DAttribute {
  mixin(AttributeThis!"CharAttribute");

  // Initialization hook method.
  override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .dataFormats(["character", "big"])
      .name("char")
      .registerPath("char");
  }
}
mixin(AttributeCalls!"CharAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DCharAttribute);
    testAttribute(CharAttribute);
  }
}