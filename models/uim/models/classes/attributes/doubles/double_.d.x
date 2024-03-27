/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.double_;

import uim.models;

@safe:
class DDoubleAttribute : DAttribute {
  mixin(AttributeThis!("Double"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    dataFormats(["floatingPoint", "big"]);
    isDouble(true);
    name("double");
    registerPath("double");

    return true;
  }
}

mixin(AttributeCalls!("Double"));

///
unittest {
}
