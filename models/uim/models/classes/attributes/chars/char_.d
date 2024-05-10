/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module models.uim.models.classes.attributes.chars.char_;

import uim.models;

@safe:
class DCharAttribute : DAttribute {
  mixin(AttributeThis!"Char");

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    dataFormats(["character", "big"]);
    name("char");
    registerPath("char");

    return true;
  }
}

mixin(AttributeCalls!"Char");

  unittest {
    testAttribute(new DCharAttribute);
    testAttribute(CharAttribute);
}
